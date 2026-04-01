{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  self = inputs.self;
in {
  config = {
    age = {
      rekey = {
        masterIdentities = [
          ./secrets/age-yubikey-identity-usbc.pub
          # "/home/tomas/.ssh/id_ed25519"
        ];

        agePlugins = with pkgs; [
          age-plugin-1p
          age-plugin-sss
          age-plugin-tpm
          age-plugin-yubikey
        ];

        storageMode = "local";
        localStorageDir = ./. + "/secrets/rekeyed/${config.networking.hostName}";
      };

      secrets = {
        nix-access-tokens-github = {
          rekeyFile = ./secrets/github.age;
          mode = "666";
        };
      };
    };

    nix.extraOptions = ''
      !include ${config.age.secrets.nix-access-tokens-github.path}
    '';

    system = {
      stateVersion = "26.05";
      nixos.tags = [
        "snowfall"
        (self.shortRev or "dirty")
      ];
      configurationRevision = lib.mkForce self.shortRev or "dirty";
    };

    nix = {
      # settings.extra-sandbox-paths = ["/tmp/agenix-rekey.${builtins.toString config.users.users.tomas.uid}"];
      registry = {
        nixpkgs.flake = inputs.nixpkgs;
        home-manager.flake = inputs.home-manager;
        darwin.flake = inputs.darwin;
      };
    };
  };
}
