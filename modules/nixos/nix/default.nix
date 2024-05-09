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
  imports = [
    "${inputs.unstable}/nixos/modules/programs/nh.nix"
  ];

  config = mkIf (!config.traits.slim.enable) {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/tomas/Developer/nix-config";
    };

    environment.systemPackages = with pkgs;
    with custom; [
      nix-update
      fup-repl
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
      package = pkgs.nix; #Unstable;

      settings =
        {
          use-cgroups = true;
          experimental-features = "nix-command flakes cgroups";
          http-connections = 50;
          # warn-dirty = false;
          # log-lines = 50;
          # sandbox = false;
          auto-optimise-store = true;
          # trusted-users = users ++ ["tomas" "root"]; # "builder"];
          # allowed-users = users ++ ["tomas" "root" "builder"];
          netrc-file = config.age.secrets.attic-netrc.path;
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

      # gc = {
      #   automatic = true;
      #   dates = "daily";
      #   options = "--delete-older-than 14d";
      # };

      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
