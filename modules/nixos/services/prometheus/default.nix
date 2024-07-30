{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.prometheus;
  format = pkgs.formats.yaml {};
in {
  options.prometheus = {enable = mkBoolOpt true "prometheus";};

  config = mkIf cfg.enable {
    system.nixos.tags = ["prometheus"];

    system.activationScripts.node-exporter-system-version = ''
      mkdir -pm 0775 /var/lib/prometheus-node-exporter-text-files
      (
        cd /var/lib/prometheus-node-exporter-text-files
        (
          echo -n "system_version ";
          readlink /nix/var/nix/profiles/system | cut -d- -f2
        ) > system-version.prom.next
        mv system-version.prom.next system-version.prom
      )
    '';

    services = {
      prometheus = {
        exporters = {
          node = {
            enable = true;
            enabledCollectors = ["systemd" "textfile"];
            disabledCollectors = ["arp"];

            extraFlags = [
              "--collector.textfile.directory=/var/lib/prometheus-node-exporter-text-files"
            ];
          };

          process.enable = true;

          nginx = {enable = true;};

          systemd.enable = true;
        };
      };

      netdata.configDir."go.d/prometheus.conf" = format.generate "prometheus.conf" {
        jobs =
          (optional config.services.prometheus.exporters.node.enable {
            name = "node";
            url = "http://127.0.0.1:${
              builtins.toString config.services.prometheus.exporters.node.port
            }/metrics";
          })
          ++ (optional config.services.prometheus.exporters.process.enable {
            name = "process";
            url = "http://127.0.0.1:${
              builtins.toString
              config.services.prometheus.exporters.process.port
            }/metrics";
          })
          ++ (optional config.services.prometheus.exporters.ipmi.enable {
            name = "ipmi";
            url = "http://127.0.0.1:${
              builtins.toString
              config.services.prometheus.exporters.ipmi.port
            }/metrics";
          })
          ++ (optional config.services.prometheus.exporters.nginx.enable {
            name = "nginx";
            url = "http://127.0.0.1:${
              builtins.toString
              config.services.prometheus.exporters.nginx.port
            }/metrics";
          })
          ++ (optional config.services.prometheus.exporters.systemd.enable {
            name = "systemd";
            url = "http://127.0.0.1:${
              builtins.toString
              config.services.prometheus.exporters.systemd.port
            }/metrics";
          });
      };
    };

    # config.services.prometheus.exporters.node.port
    # config.services.prometheus.exporters.idrac
    # config.services.prometheus.exporters.ping
    # config.services.prometheus.exporters.nginx
    # config.services.prometheus.exporters.systemd
    # config.services.prometheus.exporters.assertions ??

    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = 3031;
          grpc_listen_port = 0;
        };
        positions = {filename = "/var/lib/promtail/positions.yaml";};
        clients = [{url = "http://silver-star:3100/loki/api/v1/push";}];
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
  };
}
