{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; {
  config = mkIf (!config.traits.slim.enable) {
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
          # warn-dirty = false;
          # log-lines = 50;
          # sandbox = false;
          # auto-optimise-store = true;
          # trusted-users = users ++ ["tomas" "root"]; # "builder"];
          # allowed-users = users ++ ["tomas" "root" "builder"];
          # # netrc-file = "/etc/nix/netrc";
          # substituters =
          #   [cfg.default-substituter.url]
          #   ++ (mapAttrsToList (name: value: name) cfg.extra-substituters);
          # trusted-public-keys =
          #   [cfg.default-substituter.key]
          #   ++ (mapAttrsToList (name: value: value.key) cfg.extra-substituters);
        }
        // (lib.optionalAttrs true {
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
