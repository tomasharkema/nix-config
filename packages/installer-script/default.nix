{ inputs, lib, jq, gum, system, writeShellApplication, writeShellScriptBin
, tailscale, krb5, configurations ? {
  "foo" = {
    config = {
      disko = { };
      system.build.diskoScript = "SCRIPT";
    };
  };
  bar = {
    _module.specialArgs.system = system;
    config = {
      disko = { };
      system.build.diskoScript = writeShellScriptBin "derp" ''
        derp
      '';
    };
  };
  skip = { config.system.build = { }; };

  skip-installer = { config.system.build = { }; };

  weird-installer = {
    config = {
      disko = { };
      system.build.diskoScript = "SCRIPT";
    };
  };
}, writeText, stdenv, }:
let
  # disko =
  #   if stdenv.isLinux
  #   then inputs.disko.packages."${system}".disko
  #   else "true";
  # originalConfigurations = lib.attrsets.filterAttrs (name: v: !(lib.strings.hasInfix "installer" name)) configurations;
  diskoScripts = lib.attrsets.concatMapAttrs (name: value:
    if ((!(lib.strings.hasInfix "installer" name))
      && ((builtins.hasAttr "_module" value) && value._module.specialArgs.system
        == system)
      && (builtins.hasAttr "diskoScript" value.config.system.build)) then {
        "${name}" = value.config.system.build.diskoScript;
      } else
      { }) configurations;

  diskoMountScripts = lib.attrsets.concatMapAttrs (name: value:
    if ((!(lib.strings.hasInfix "installer" name))
      && ((builtins.hasAttr "_module" value) && value._module.specialArgs.system
        == system)
      && (builtins.hasAttr "diskoScript" value.config.system.build)) then {
        "${name}" = value.config.system.build.mountScript;
      } else
      { }) configurations;

  diskoScriptsJsonString = builtins.toJSON diskoScripts;
  diskoMountScriptsJsonString = builtins.toJSON diskoMountScripts;

  diskoScriptsJson =
    #builtins.trace diskoScriptsJsonString
    writeText "diskoMappings.json" diskoScriptsJsonString;

  diskoMountScriptsJson =
    writeText "diskoMountMappings.json" diskoMountScriptsJsonString;

  configurationNames = lib.attrNames diskoScripts;
  configurationNamesString =
    #builtins.trace configurationNames
    builtins.concatStringsSep "\n" configurationNames;
  hosts =
    #builtins.trace configurationNamesString
    writeText "hosts.txt" configurationNamesString;
  # builtins.trace (builtins.toJSON "${hosts} ${diskoScriptsJson}")
in writeShellApplication {
  name = "installer-script";

  runtimeInputs = [
    krb5
    gum
    # tailscale
    jq
  ];

  text = ''
    set -e

    function tailscaleStatus () {
      TAILSCALE_STATUS="$(tailscale status --json | jq -r '.BackendState')"
      case "$TAILSCALE_STATUS" in
        "Running")
          return 0
          ;;

        *)
          return 1
          ;;
      esac
    }

    # tailscaleStatus || {
    #   echo "Login with Tailscale..."

    #   tailscale up --qr --accept-dns --accept-routes
    # }

    HOSTNAME_INST="$(gum choose --header Hostname < ${hosts})"

    echo "Installing $HOSTNAME_INST..."

    DISKO_COMMAND="$(jq -r ".\"$HOSTNAME_INST\"" < ${diskoScriptsJson})"
    DISKO_MOUNT_COMMAND="$(jq -r ".\"$HOSTNAME_INST\"" < ${diskoMountScriptsJson})"

    # shellcheck disable=SC1090
    "$DISKO_MOUNT_COMMAND" || {
      # shellcheck disable=SC1090
      gum confirm "Format disk?" && "$DISKO_COMMAND"
    }

    gum confirm "Ready to install?" && nixos-install --flake "github:tomasharkema/nix-config#$HOSTNAME_INST" --verbose
  '';
}
