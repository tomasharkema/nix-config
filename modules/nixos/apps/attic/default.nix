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
  options.apps.attic = with lib.types; {
    enable = mkEnableOption "enable attic conf";

    serverName = mkOption {
      default = "tomas";
      type = str;
    };

    storeName = mkOption {
      default = "tomas";
      type = str;
    };

    serverAddress = mkOption {
      default = "http://192.168.0.100:6067/";
      type = str;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.attic-watch-store = {
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
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
        whoami
        ATTIC_TOKEN=$(< $CREDENTIALS_DIRECTORY/prod-auth-token)
        # Replace https://cache.<domain> with your own cache URL.
        attic login ${cfg.serverName} ${cfg.serverAddress} $ATTIC_TOKEN
        attic use ${cfg.serverName}
        exec attic watch-store ${cfg.serverName}:${cfg.storeName}
      '';
    };

    nix.settings.trusted-users = ["attic-watch-store"];
  };
}
