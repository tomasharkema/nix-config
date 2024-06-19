{
  inputs,
  options,
  config,
  pkgs,
  lib,
  system,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.custom.nix;
in {
  imports = [
    # inputs.agenix.darwinModules.default
  ];

  options = {
    gui = {
      enable = mkBoolOpt false "Whether or not to manage nix configuration.";
      gnome.enable =
        mkBoolOpt false "Whether or not to manage nix configuration.";
    };
  };

  config = {
    age = {
      # identityPaths = [
      #   "/etc/ssh/ssh_host_ed25519_key"
      # ];
      secrets = {
        "attic-config.toml" = {
          file = ../../nixos/secrets/attic-config.toml.age;
          mode = "777";
          owner = "tomas";
          group = "tomas";
          path = "/Users/tomas/.config/attic/config.toml";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      deploy-rs
      nixfmt-rfc-style

      nix-prefetch-git
      nil
      nixd
      flake-checker
      direnv
      devenv
      # attic
      nix-output-monitor
      nerd-font-patcher
      alejandra
    ];
    traits.developer.enable = true;

    services.nix-daemon.enable = true;

    # age.secrets."op" = {
    #   file = ../../../secrets/op.age;
    #   mode = "744";
    #   # path = "/home/tomas/.google_authenticator";
    #   # owner = "tomas";
    #   # group = "tomas";
    # };

    nix = let
      users = ["root" "tomas"];
    in {
      package = pkgs.nixVersions.nix_2_22;

      linux-builder = {
        enable = true;
        ephemeral = true;
        maxJobs = 4;
        systems = ["x86_64-linux" "aarch64-linux"];
        config = {
          virtualisation = {
            # rosetta.enable = true;
            darwin-builder = {
              diskSize = 30 * 1024;
              memorySize = 4 * 1024;
            };
            cores = 4;
          };
        };
      };

      settings = {
        http-connections = 50;
        warn-dirty = false;
        log-lines = 50;

        # Large builds apparently fail due to an issue with darwin:
        # https://github.com/NixOS/nix/issues/4119
        sandbox = false;

        # This appears to break on darwin
        # https://github.com/NixOS/nix/issues/7273
        auto-optimise-store = false;

        allow-import-from-derivation = true;

        trusted-users = users;
        allowed-users = users;

        keep-outputs = true;
        keep-derivations = true;
        accept-flake-config = true;

        # NOTE: This configuration is generated by nix-installer so I'm adding it here in
        # case it becomes important.
        #extra-nix-path = "nixpkgs=flake:nixpkgs";
        build-users-group = "nixbld";
      };
      # // (lib.optionalAttrs config.plusultra.tools.direnv.enable {
      #   keep-outputs = true;
      #   keep-derivations = true;
      # });

      gc = {
        automatic = true;
        interval = {Day = 1;};
        options = "--delete-older-than 14d";
        user = "tomas";
      };

      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
