{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.prometheus;
  format = pkgs.formats.yaml {};
in {
  options.prometheus = {enable = lib.mkEnableOption "prometheus" // {default = true;};};

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["prometheus"];

    age.secrets."promtail".rekeyFile = ./promtail.age;

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
          (lib.optional config.services.prometheus.exporters.node.enable {
            name = "node";
            url = "http://127.0.0.1:${
              builtins.toString config.services.prometheus.exporters.node.port
            }/metrics";
          })
          ++ (lib.optional config.services.prometheus.exporters.process.enable {
            name = "process";
            url = "http://127.0.0.1:${
              builtins.toString
              config.services.prometheus.exporters.process.port
            }/metrics";
          })
          ++ (lib.optional config.services.prometheus.exporters.ipmi.enable {
            name = "ipmi";
            url = "http://127.0.0.1:${
              builtins.toString
              config.services.prometheus.exporters.ipmi.port
            }/metrics";
          })
          ++ (lib.optional config.services.prometheus.exporters.nginx.enable {
            name = "nginx";
            url = "http://127.0.0.1:${
              builtins.toString
              config.services.prometheus.exporters.nginx.port
            }/metrics";
          })
          ++ (lib.optional config.services.prometheus.exporters.systemd.enable {
            name = "systemd";
            url = "http://127.0.0.1:${
              builtins.toString
              config.services.prometheus.exporters.systemd.port
            }/metrics";
          });
      };
    };

    services.promtail = {
      enable = true;
      extraFlags = ["--config.expand-env=true"];
      configuration = {
        server = {
          http_listen_port = 0;
          grpc_listen_port = 0;
        };
        positions = {filename = "/var/lib/promtail/positions.yaml";};
        # positions = {filename = "/tmp/positions.yaml";};
        clients = [
          {url = "http://silver-star:3100/loki/api/v1/push";}

          {
            url = "https://logs-prod-012.grafana.net/loki/api/v1/push";

            basic_auth = {
              username = "1033315";
              password_file = "";
            };
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
  };
}
