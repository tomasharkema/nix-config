{
  inputs,
  options,
  config,
  pkgs,
  lib,
  system,
  ...
}: let
  cfg = config.custom.nix;
in {
  imports = [
    ../../../nix-pkgs.nix
  ];

  options = {
    gui = {
      enable = lib.mkEnableOption "Whether or not to manage nix configuration.";
      gnome.enable =
        lib.mkEnableOption "Whether or not to manage nix configuration.";
    };
  };

  config = {
    age = {
      secrets = {
        "attic-config.toml" = {
          rekeyFile = ../../nixos/secrets/attic-config.toml.age;
          # mode = "777";
          owner = "${config.user.name}";
          # group = "tomas";
          path = "/Users/${config.user.name}/.config/attic/config.toml";
        };
      };
    };

    traits.developer.enable = true;

    services.nix-daemon.enable = true;
    programs.direnv.enable = true;
    # age.secrets."op" = {
    #   rekeyFile = ../../../secrets/op.age;
    #   mode = "744";
    #   # path = "/home/tomas/.google_authenticator";
    #   # owner = "tomas";
    #   # group = "tomas";
    # };

    environment = {
      systemPackages = with pkgs; [age-plugin-yubikey];
      variables = {
        # OTEL_EXPORTER_OTLP_ENDPOINT = "http://silver-star:8428/opentelemetry/v1/metrics";
        # OTEL_EXPORTER_OTLP_TRACES_PROTOCOL = "http/json";
      };
    };

    nix = let
      users = ["root" "${config.user.name}"];
    in {
      # package = pkgs.nixVersions.nix_2_23; #.latest;

      # nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      linux-builder = {
        enable = true;
        ephemeral = true;
        maxJobs = 4;
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        config = {
          virtualisation = {
            # rosetta.enable = true;
            darwin-builder = {
              diskSize = 40 * 1024;
              memorySize = 6 * 1024;
            };
            cores = 4;
          };
        };
      };

      # extraOptions = ''
      #   plugin-files = ${pkgs.nix-otel}/lib
      # '';

      settings = {
        http-connections = 50;
        warn-dirty = false;
        log-lines = 50;

        # Large builds apparently fail due to an issue with darwin:
        # https://github.com/NixOS/nix/issues/4119
        # sandbox = false;

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
        # extra-nix-path = "nixpkgs=flake:nixpkgs";
        build-users-group = "nixbld";
      };

      gc = {
        automatic = true;
        interval = {Day = 1;};
        options = "--delete-older-than 14d";
        user = "${config.user.name}";
      };

      # flake-utils-plus
      # generateRegistryFromInputs = true;
      # generateNixPathFromInputs = true;
      # linkInputs = true;
    };
  };
}
