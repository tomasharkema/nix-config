{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.prometheus;
in {
  options.prometheus = {
    enable = mkBoolOpt true "SnowflakeOS GNOME configuration";
  };

  config = mkIf cfg.enable {
    services.promtail = lib.mkIf false {
      enable = false;
      configuration = {
        server = {
          http_listen_port = 3031;
          grpc_listen_port = 0;
        };
        positions = {
          filename = "/tmp/positions.yaml";
        };
        clients = [
          {
            url = "http://100.122.146.5:3100/loki/api/v1/push";
          }
        ];
        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              max_age = "12h";
              labels = {
                job = "systemd-journal";
                host = config.networking.hostName;
              };
            };
            relabel_configs = [
              {
                source_labels = ["__journal__systemd_unit"];
                target_label = "unit";
              }
            ];
          }
        ];
      };
      # extraFlags
    };

    services.prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = ["systemd"];
          disabledCollectors = ["arp"];
        };
        process.enable = true;
      };
    };
  };
}
