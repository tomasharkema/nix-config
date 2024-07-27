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
      wantedBy = ["default.target"];
      after = ["network-online.target" "nix-daemon.service"];

      environment.HOME = "/var/lib/attic-watch-store";

      serviceConfig = {
        DynamicUser = true;
        MemoryHigh = "5%";
        MemoryMax = "10%";
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
