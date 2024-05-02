{
  inputs,
  lib,
  jq,
  gum,
  system,
  writeShellApplication,
  tailscale,
  configurations ? {
    "foo" = {};
    bar = {};
  },
  writeText,
  stdenv,
}: let
  disko =
    if stdenv.isLinux
    then inputs.disko.packages."${system}".disko
    else "true";

  configurationNames = lib.attrNames configurations;
  configurationNamesString = builtins.trace configurationNames (builtins.toString configurationNames);
  hosts = builtins.trace configurationNamesString (writeText "hosts.txt" ''
    ${configurationNamesString}
  '');

  tailscaleStatus = writeShellApplication {
    name = "tailscaleStatus";

    runtimeInputs = [
      tailscale
      jq
    ];

    text = ''
      set -ex
      TAILSCALE_STATUS="$(tailscale status --json | jq -r '.BackendState')"
      case "$TAILSCALE_STATUS" in
        "Stopped")
          exit 1
          ;;

        *)
          exit 0
          ;;
      esac
    '';
  };
in
  writeShellApplication {
    name = "installer";

    runtimeInputs = [
      tailscaleStatus
      gum
      tailscale
      jq
    ];

    text = ''
      set -ex

      function tailscaleStatus () {
        TAILSCALE_STATUS="$(tailscale status --json | jq -r '.BackendState')"
        case "$TAILSCALE_STATUS" in
          "Stopped")
            return 1
            ;;

          *)
            return 0
            ;;
        esac
      }


      tailscaleStatus || {
        echo "Login with Tailscale..."

        tailscale up --qr --accept-dns
      }

      HOSTNAME_INST="$(gum filter --placeholder Hostname < ${hosts})"

      echo "Installing $HOSTNAME_INST..."
      disko --mode mount --flake "github:tomasharkema/nix-config#$HOSTNAME_INST" || {
        gum confirm "Format disk?" && disko --mode disko --flake "github:tomasharkema/nix-config#$HOSTNAME_INST"
      }

    '';
  }
