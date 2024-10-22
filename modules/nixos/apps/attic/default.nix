{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.attic;
in {
  options.apps.attic = {
    enable = lib.mkEnableOption "enable attic conf";

    serverName = lib.mkOption {
      default = "backup";
      type = lib.types.str;
    };

    storeName = lib.mkOption {
      default = "tomas";
      type = lib.types.str;
    };

    serverAddress = lib.mkOption {
      default = "http://silver-star:6067/";
      # default = "https://nix-cache.harke.ma/";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.attic-key = {
      rekeyFile = ./attic-key.age;
    };

    systemd.services.attic-watch-store = {
      after = ["tailscaled.service" "network-online.target"];
      wants = ["tailscaled.service" "network-online.target"];
      wantedBy = ["multi-user.target"];

      environment.HOME = "/var/lib/attic-watch-store";

      unitConfig = {
        # allow to restart indefinitely
        StartLimitIntervalSec = 0;
      };

      serviceConfig = {
        KillMode = "process";
        Restart = "on-failure";
        RestartSec = 5;
        DynamicUser = true;
        MemoryHigh = "5%";
        MemoryMax = "10%";
        Nice = 10;

        LoadCredential = "prod-auth-token:${config.age.secrets.attic-key.path}";
        StateDirectory = "attic-watch-store";
      };

      path = [pkgs.attic-client];
      script = ''
        set -eux -o pipefail
        ATTIC_TOKEN=$(< $CREDENTIALS_DIRECTORY/prod-auth-token)

        attic login ${cfg.serverName} ${cfg.serverAddress} $ATTIC_TOKEN

        exec attic watch-store ${cfg.serverName}:${cfg.storeName} -j1
      '';
    };

    nix.settings = {
      trusted-users = ["attic-watch-store"];
      allowed-users = ["attic-watch-store"];
    };
  };
}
