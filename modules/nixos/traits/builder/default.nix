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

  config = mkIf cfg.enable {
    apps.attic.enable = true;

    # services.postgresql.enable = true;
    systemd.services.hydra-queue-runner.path = [pkgs.ssmtp];
    systemd.services.hydra-server.path = [pkgs.ssmtp];

    services.hydra = {
      extraEnv = {
        HYDRA_FORCE_SEND_MAIL = "1";
        EMAIL_SENDER_TRANSPORT_port = 587;
        EMAIL_SENDER_TRANSPORT_ssl = "starttls";
        EMAIL_SENDER_TRANSPORT_host = "smtp-relay.gmail.com";
      };

      enable = true;
      hydraURL = "hydra.harkema.io";
      notificationSender = "tomas+hydra@harkema.io";
      buildMachinesFiles = [];
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
      };
      # binaryCaches = mkForce ["https://cache.nixos.org"];
      settings.trusted-users = ["hydra" "hydra-queue-runner" "hydra-www"];
    };

    programs.nix-ld.enable = true;

    nix.sshServe = {
      # enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas@tomas"
      ];
    };

    services.vscode-server.enable = true;
  };
}
