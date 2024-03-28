{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.custom.nix;

  substituters-submodule = types.submodule ({name, ...}: {
    options = with types; {
      key = mkOpt (nullOr str) null "The trusted public key for this substituter.";
    };
  });
in {
  options.custom.nix = with types; {
    enable = mkBoolOpt true "Whether or not to manage nix configuration.";
    package = mkOpt package inputs.unstable "Which nix package to use.";

    default-substituter = {
      url = mkOpt str "https://cache.nixos.org" "The url for the substituter.";
      key = mkOpt str "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "The trusted public key for the substituter.";
    };

    extra-substituters = mkOpt (attrsOf substituters-submodule) {} "Extra substituters to configure.";
  };

  config = mkIf (cfg.enable && !config.traits.slim.enable) {
    assertions =
      mapAttrsToList
      (name: value: {
        assertion = value.key != null;
        message = "custom.nix.extra-substituters.${name}.key must be set";
      })
      cfg.extra-substituters;

    environment.systemPackages = with pkgs;
    with custom; [
      # custom.nixos-revision
      # (nixos-hosts.override {
      #   hosts = inputs.self.nixosConfigurations;
      # })
      attic
    ];

    nix = let
      users =
        ["root" config.user.name]
        ++ optional config.services.hydra.enable "hydra";
    in {
      # package = cfg.package;

      settings =
        {
          use-cgroups = true;
          experimental-features = "nix-command flakes cgroups";
          http-connections = 50;
          warn-dirty = false;
          log-lines = 50;
          sandbox = false;
          auto-optimise-store = true;
          trusted-users = users ++ ["tomas" "root"]; # "builder"];
          allowed-users = users ++ ["tomas" "root" "builder"];
          netrc-file = "/etc/nix/netrc";
          substituters =
            [cfg.default-substituter.url]
            ++ (mapAttrsToList (name: value: name) cfg.extra-substituters);
          trusted-public-keys =
            [cfg.default-substituter.key]
            ++ (mapAttrsToList (name: value: value.key) cfg.extra-substituters);
        }
        // (lib.optionalAttrs true {
          # config.custom.tools.direnv.enable {
          keep-outputs = true;
          keep-derivations = true;
        });

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 14d";
      };

      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
