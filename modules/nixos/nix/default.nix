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
    #   "${inputs.unstable}/nixos/modules/programs/nh.nix"
    ../../../nix-pkgs.nix
  ];

  config = mkIf (!config.traits.slim.enable) {
    # programs.nh = {
    #   enable = true;
    #   clean.enable = true;
    #   clean.extraArgs = "--keep-since 4d --keep 3";
    #   flake = "/home/tomas/Developer/nix-config";
    # };

    nix = let
      users =
        [
          "root"
          config.user.name
        ]
        ++ optional config.services.hydra.enable "hydra";
    in {
      package = pkgs.nixVersions.latest;

      extraOptions = ''
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
      '';

      optimise.automatic = true;

      settings = {
        use-cgroups = true;
        experimental-features = "nix-command flakes cgroups";
        http-connections = 50;
        warn-dirty = false;
        log-lines = 50;
        sandbox = true;
        auto-optimise-store = true;
        trusted-users =
          users
          ++ [
            "tomas"
            "root"
            "builder"
          ];
        allowed-users =
          users
          ++ [
            "tomas"
            "root"
            "builder"
          ];
        #netrc-file = config.age.secrets.attic-netrc.path ++ config.age.secrets.netrc.path;
        netrc-file = config.age.secrets.netrc.path;
        keep-outputs = true;
        keep-derivations = true;
        # substituters =
        #   [cfg.default-substituter.url]
        #   ++ (mapAttrsToList (name: value: name) cfg.extra-substituters);
        # trusted-public-keys =
        #   [cfg.default-substituter.key]
        #   ++ (mapAttrsToList (name: value: value.key) cfg.extra-substituters);
      };

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
