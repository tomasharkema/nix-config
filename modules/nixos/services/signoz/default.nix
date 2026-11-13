{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.signoz;
in {
  options.services.signoz = {
    enable = lib.mkEnableOption "signoz";
  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl."kernel.task_delayacct" = 1;

    services = {
      zookeeper = {
        enable = true;
        extraConf = ''
          tickTime=2000
          dataDir=/var/lib/zookeeper
          clientPort=2181
          admin.serverPort=3181
        '';
      };

      clickhouse = {
        enable = true;
        serverConfig = {
          http_port = 8124;
          tcp_port = 9000;

          distributed_ddl = {
            path = "/clickhouse/task_queue/ddl";
          };

          remote_servers = {
            cluster.shard.replica = {
              host = "127.0.0.1";
              port = 9000;
            };
          };
          zookeeper = {
            node = {
              host = "127.0.0.1";
              port = 2181;
            };
          };

          macros = {
            shard = "01";
            replica = "01";
          };
        };
      };
    };
  };
}
