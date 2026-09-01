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
    # nm-overrides.desktop.home-exec.enable = false;

    system.configurationRevision = lib.mkForce (self.shortRev or "dirty");

    nix = {
      extraOptions = ''
        !include ${config.age.secrets.nix-access-tokens-github.path}
      '';

      registry = {
        nixpkgs.flake = inputs.nixpkgs;
        home-manager.flake = inputs.home-manager;
        darwin.flake = inputs.darwin;
      };
      # settings.extra-sandbox-paths = ["/tmp/agenix-rekey.${builtins.toString config.users.users."${config.user.name}".uid}"];
    };

    age = {
      secrets = {
        nix-access-tokens-github = {
          rekeyFile = ../../../../secrets/github.age;
          mode = "666";
        };
      };

      rekey = {
        masterIdentities = [
          ../../../../secrets/age-yubikey-identity-usbc.pub
          # ./secrets/age-op-identity-ed.pub
        ];

        agePlugins = with pkgs; [
          age-plugin-1p
          # age-plugin-fido2-hmac
          age-plugin-yubikey
        ];

        storageMode = "local";
        localStorageDir = self.outPath + "/secrets/rekeyed/${config.networking.hostName}";
      };
    };

    environment.systemPackages = with pkgs; [
      age-plugin-1p
      # age-plugin-tpm
      age-plugin-yubikey
    ];
  };
}
