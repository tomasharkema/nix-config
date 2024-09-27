{
  config,
  lib,
  inputs,
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
        # extraEncryptionPubkeys = [
        #   ./secrets/age-yubikey-identity-usba.pub
        # ];

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
      stateVersion = "24.11";
      nixos.tags = [
        "snowfall"
        (self.shortRev or "dirty")
      ];
      configurationRevision = lib.mkForce (self.shortRev or "dirty");
    };

    nix = {
      # settings.extra-sandbox-paths = ["/tmp/agenix-rekey.${builtins.toString config.users.users.tomas.uid}"];
      registry = {
        nixpkgs.flake = inputs.nixpkgs;
        home-manager.flake = inputs.home-manager;
        darwin.flake = inputs.darwin;
        tomas = {
          from = {
            type = "indirect";
            id = "tomas";
          };
          to = {
            type = "github";
            owner = "tomasharkema";
            repo = "nix-config";
          };
        };
      };
    };
  };
}
