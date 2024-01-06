{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.builder;
in {
  imports = with inputs; [
    vscode-server.nixosModules.default
  ];

  options.traits = {
    builder = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = let
    github-default = {
      enable = true;
      tokenFile = config.age.secrets.ght-runner.path;
      url = "https://github.com/tomasharkema/nix-config";
      ephemeral = true;
    };
  in
    mkIf cfg.enable {
      age.secrets.ght = {
        file = ../../../../secrets/ght.age;
        mode = "0664";
      };
      age.secrets."ght-runner" = {
        file = ../../../../secrets/ght-runner.age;
        mode = "0664";
      };

      apps.attic.enable = true;
      services.github-runners."runner-1" = github-default;
      services.github-runners."runner-2" = github-default;

      networking.extraHosts = ''
        127.0.0.2 localhost-aarch64
      '';

      nix.buildMachines = [
        {
          hostName = "localhost";
          systems = ["x86_64-linux" "aarch64-linux"];
          supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
          maxJobs = 8;
        }
      ];

      services.hydra = {
        extraEnv = {
          # HYDRA_FORCE_SEND_MAIL = "1";
          EMAIL_SENDER_TRANSPORT_port = "587";
          EMAIL_SENDER_TRANSPORT_ssl = "starttls";
          EMAIL_SENDER_TRANSPORT_host = "smtp-relay.gmail.com";
        };

        # buildMachinesFiles = [];

        enable = true;
        hydraURL = "https://hydra.harkema.io";
        notificationSender = "tomas+hydra@harkema.io";
        useSubstitutes = true;
        smtpHost = "smtp-relay.gmail.com";
        extraConfig = ''
          Include ${config.age.secrets.ght.path}
          <hydra_notify>
            <prometheus>
              listen_address = 0.0.0.0
              port = 9199
            </prometheus>
          </hydra_notify>
          <githubstatus>
            ## This example will match all jobs
            jobs = .*
            inputs = src
            excludeBuildFromContext = 1
          </githubstatus>
          using_frontend_proxy 1
          email_notification = 1
        '';
      };

      programs.ssh.extraConfig = ''
        StrictHostKeyChecking no
      '';
      nix = {
        extraOptions = ''
          auto-optimise-store = true
        '';
        # allowed-uris = https://github.com/zhaofengli/nix-base32.git https://github.com/tomasharkema.keys https://api.flakehub.com/f/pinned https://github.com/NixOS/nixpkgs/archive https://github.com/NixOS/nixpkgs-channels/archive https://github.com/input-output-hk https://github.com/tomasharkema

        settings = {
          allowed-uris = [
            "https://api.github.com"
            "https://git.sr.ht/~rycee/nmd/archive"
            "https://github.com/zhaofengli/nix-base32.git"
            "https://github.com/tomasharkema.keys"
            "https://api.flakehub.com/f/pinned"
            "https://github.com/NixOS/"
            "https://github.com/nixos/"
            "https://github.com/hercules-ci/"
            "https://github.com/numtide/"
            "https://github.com/cachix/"
            "https://github.com/nix-community/"
            "https://github.com/tomasharkema/"
            "git://github.com/tomasharkema"
          ];
          allow-import-from-derivation = true;

          substituters = [
            "https://tomasharkema.cachix.org/"
            "https://nix-cache.harke.ma/tomas/"
            "https://nix-community.cachix.org/"
            "https://cache.nixos.org/"
          ];

          trusted-public-keys = [
            "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
            "tomas:/cvjdgRjoTx9xPqCkeMWkf9csRSAmnqLgN3Oqkpx2Tg="
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];

          trusted-users = ["hydra" "hydra-queue-runner" "hydra-www" "github-runner-blue-fire"];
        };
      };

      programs.nix-ld.enable = true;

      nix.sshServe = {
        enable = true;
        keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas@tomas"
        ];
      };
      services.nix-serve = {
        enable = true;
        secretKeyFile = "/var/cache-priv-key.pem";
      };

      services.vscode-server.enable = true;

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts = {
          "hydra-cache.harkema.io" = {
            locations."/".proxyPass = "http://127.0.0.1:${toString config.services.nix-serve.port}";
          };
          "hydra.harkema.io" = {
            locations."/".proxyPass = "http://127.0.0.1:${toString config.services.hydra.port}";
          };
          "hydra.${config.networking.hostName}.ling-lizard.ts.net" = {
            locations."/".proxyPass = "http://127.0.0.1:${toString config.services.hydra.port}";
          };
          "hydra-cache.${config.networking.hostName}.ling-lizard.ts.net" = {
            locations."/".proxyPass = "http://127.0.0.1:${toString config.services.nix-serve.port}";
          };
        };
      };
    };
}
