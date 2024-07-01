{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.builder.hydra;
in {
  options.traits = {
    builder.hydra = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    networking.extraHosts = ''
      127.0.0.1 localhost-aarch64
    '';

    age.secrets = {
      "ldap" = {
        file = ../../../secrets/ldap.age;
        mode = "644";
        # owner = "tomas";
        # group = "tomas";
      };
      ght = {
        file = ../../../secrets/ght.age;
        mode = "0664";
      };
    };

    systemd.services = {
      hydra-queue-runner.serviceConfig.Nice = 10;
      hydra-evaluator.serviceConfig = {
        MemoryHigh = "5G";
        MemoryMax = "9G";
        MemoryLimit = "10G";
        Nice = 10;
      };
    };

    nix.buildMachines = [
      {
        hostName = "localhost";
        systems = ["x86_64-linux" "aarch64-linux" "i686-linux"];
        supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
        maxJobs = 1;
      }
      # {
      #   hostName = "builder@wodan";
      #   systems = ["x86_64-linux" "aarch64-linux" "i686-linux"];
      #   supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
      #   maxJobs = 2;
      #   speedFactor = 100;
      # }
      # {
      #   hostName = "builder@enzian";
      #   systems = ["x86_64-linux" "aarch64-linux" "i686-linux"];
      #   supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
      #   maxJobs = 1;
      #   speedFactor = 50;
      # }
      # {
      #   hostName = "builder@arthur";
      #   systems = ["x86_64-linux" "aarch64-linux" "i686-linux"];
      #   supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
      #   maxJobs = 1;
      #   speedFactor = 10;
      # }
    ];

    networking.firewall = {allowedTCPPorts = [3000];};

    services.hydra = {
      extraEnv = {
        # HYDRA_FORCE_SEND_MAIL = "1";
        EMAIL_SENDER_TRANSPORT_port = "8025";
        # EMAIL_SENDER_TRANSPORT_ssl = "starttls";
        EMAIL_SENDER_TRANSPORT_host = "silver-star-vm.ling-lizard.ts.net";
      };

      enable = true;
      hydraURL = "https://hydra.harkema.io";
      notificationSender = "tomas+hydra@harkema.io";
      useSubstitutes = true;
      smtpHost = "silver-star-vm.ling-lizard.ts.net";
      debugServer = false;
      listenHost = "0.0.0.0";
      port = 3000;

      extraConfig = let
        ldap = import ./ldap.nix {inherit pkgs config;};
      in ''
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
        Include ${ldap}
      '';
    };

    programs.ssh.extraConfig = ''
      StrictHostKeyChecking no
    '';
    nix = {
      # extraOptions = ''
      #   auto-optimise-store = true
      #   allowed-uris = https:// github:NixOS/ github:nixos/ github:hercules-ci/ github:numtide/ github:cachix/ github:nix-community/ github:snowfallorg/
      # '';
      settings = {
        # use-cgroups = true;
        #     allowed-uris = [
        #       "https://github.com/tomasharkema.keys"
        #       "https://api.github.com"
        #       "https://github.com/zhaofengli/nix-base32.git"
        #       "https://github.com/tomasharkema.keys"
        #       "https://api.flakehub.com/f/pinned"
        #       "https://github.com/NixOS/"
        #       "https://github.com/nixos/"
        #       "https://github.com/hercules-ci/"
        #       "https://github.com/numtide/"
        #       "https://github.com/cachix/"
        #       "https://github.com/nix-community/"
        #       "https://github.com/tomasharkema/"
        #       "git://github.com/tomasharkema"
        #       "https://git.sr.ht/~rycee/nmd/archive"
        #       "https://git.sr.ht/~youkai/nscan"
        #     ];
        allow-import-from-derivation = true;

        #     substituters = [
        #       "https://nix-cache.harke.ma/tomas/"
        #       "https://nix-community.cachix.org/"
        #       "https://cache.nixos.org/"
        #     ];

        #     trusted-public-keys = [
        #       "tomas:/cvjdgRjoTx9xPqCkeMWkf9csRSAmnqLgN3Oqkpx2Tg="
        #       "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        #       "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        #     ];

        trusted-users = [
          "hydra"
          "hydra-queue-runner"
          "hydra-www"
          "github-runner-blue-fire"
          "builder"
        ];
      };
    };

    # nix.sshServe = {
    #   enable = true;
    #   keys = [
    #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas@tomas"
    #   ];
    # };
    # services.nix-serve = {
    #   enable = true;
    #   secretKeyFile = "/var/cache-priv-key.pem";
    # };

    proxy-services.services = {
      "/hydra" = {
        proxyPass = "http://127.0.0.1:${toString config.services.hydra.port}";
        extraConfig = ''
          rewrite /hydra(.*) $1 break;
        '';
      };
    };

    # services.nginx = {
    #   enable = true;
    #   recommendedProxySettings = true;
    #   virtualHosts = {
    #     "hydra-cache.harkema.io" = {
    #       locations."/".proxyPass = "http://127.0.0.1:${toString config.services.nix-serve.port}";
    #     };
    #     "hydra.harkema.io" = {
    #       locations."/".proxyPass = "http://127.0.0.1:${toString config.services.hydra.port}";
    #     };
    #     "hydra.${config.networking.hostName}.ling-lizard.ts.net" = {
    #       locations."/".proxyPass = "http://127.0.0.1:${toString config.services.hydra.port}";
    #     };
    #     "hydra-cache.${config.networking.hostName}.ling-lizard.ts.net" = {
    #       locations."/".proxyPass = "http://127.0.0.1:${toString config.services.nix-serve.port}";
    #     };
    #   };
    # };
  };
}
