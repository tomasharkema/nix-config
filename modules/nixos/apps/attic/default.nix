{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib;
with pkgs; let
  cfg = config.apps.attic;
in {
  options.apps.attic = {
    enable = mkEnableOption "enable attic conf";

    serverName = mkOption {
      default = "backup";
      type = types.str;
    };

    storeName = mkOption {
      default = "tomas";
      type = types.str;
    };

    serverAddress = mkOption {
      default = "http://192.168.0.100:6067/";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.attic-key = {
      rekeyFile = ./attic-key.age;
    };

    systemd.services.attic-watch-store = {
      # wants = ["network-online.target"];
      # after = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      environment.HOME = "/var/lib/attic-watch-store";

      unitConfig = {
        # allow to restart indefinitely
        StartLimitIntervalSec = 0;
      };

      serviceConfig = {
        KillMode = "process";
        Restart = "on-failure";
        RestartSec = 1;
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
