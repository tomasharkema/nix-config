{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.fleet;
in {
  options.services.fleet = {
    enable = lib.mkEnableOption "fleet";
    database = {
      name = lib.mkOption {
        default = "fleet";
        type = lib.types.str;
      };
      user = lib.mkOption {
        default = "fleet";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups."${cfg.database.user}" = {};
      users."${cfg.database.user}" = {
        group = "${cfg.database.user}";
        isSystemUser = true;
      };
    };

    services.mysql = {
      enable = true;
      ensureDatabases = [cfg.database.name];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "all privileges";
          };
        }
      ];
    };

    systemd.services.fleet = {
      # [Unit]
      description = "Fleet";
      after = ["network.target"];

      serviceConfig = {
        User = "${cfg.database.user}";
        Group = "${cfg.database.user}";
        Type = "simple";
        LimitNOFILE = 8192;
        ExecStart = ''
          ${pkgs.fleet}/bin/fleet serve \
            --mysql_address=127.0.0.1:3306 \
            --mysql_database=fleet \
            --mysql_username=fleet \
            --mysql_password=toor \
            --redis_address=127.0.0.1:6379 \
            --server_cert=/tmp/server.cert \
            --server_key=/tmp/server.key \
            --logging_json
        '';
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
