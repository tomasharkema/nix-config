{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.apps.prometheus.server;
  machines = inputs.self.machines.all;
in {
  config = lib.mkIf cfg.enable {
    systemd.services.gpsd-exporter = {
      description = "gpsd-exporter";
      wantedBy = ["default.target" "prometheus.service"];
      after = ["network.target" "network-online.target"];
      script = ''
        exec ${lib.getExe pkgs.custom.gpsd-exporter} -d 192.168.9.149:2947
      '';
    };

    environment.etc."prometheus/nixos.json".text = builtins.toJSON [
      {
        targets = builtins.map (name: "${name}:9100") machines;
        labels = {
          service = "nixos";
          job = "nixos";
        };
      }
    ];

    services = {
      mimir = {
        enable = true;

        configuration = {
          blocks_storage = {
            backend = "filesystem";
            bucket_store = {
              sync_dir = "/tmp/mimir/tsdb-sync";
            };
            filesystem = {
              dir = "/tmp/mimir/data/tsdb";
            };
            tsdb = {
              dir = "/tmp/mimir/tsdb";
            };
          };
        };
      };

      prometheus = {
        enable = true;
        # pushgateway.enable = true;
        port = 9999;

        alertmanager = {
          enable = true;
          configuration = {
            route = {
              group_by = ["alertname"];
              group_wait = "30s";
              group_interval = "5m";
              repeat_interval = "1h";
              receiver = "web.hook";
            };
            receivers = [
              {
                name = "web.hook";
                webhook_configs = [
                  {url = "http://127.0.0.1:9998/";}
                ];
              }
            ];
          };
        };

        alertmanager-ntfy = {
          enable = true;
          settings = {
            http.addr = "127.0.0.1:9998";
            ntfy = {
              baseurl = "https://ntfy.sh";
              notification.topic = "tomasharkema-nixos";
            };
          };
        };

        ruleFiles = [
          (pkgs.fetchurl {
            url = "https://gist.github.com/krisek/62a98e2645af5dce169a7b506e999cd8/raw/b67dd1dad1bcf2896f56dd02a657d8eac8e893ea/alert.rules.yml";
            sha256 = "1mcrd16zpmb83i1gca024cg672z9i9p8yi1cjv1z9jkjalr94ids";
          })
        ];

        scrapeConfigs = [
          {
            job_name = "node-exporter";

            file_sd_configs = [
              {
                files = ["/etc/prometheus/nixos.json"];
              }
            ];
          }

          {
            job_name = "gpsd-exporter";
            static_configs = [
              {
                targets = ["localhost:9978"];
              }
            ];
          }

          {
            job_name = "ipmi-exporter";
            static_configs = let
              port = config.services.prometheus.exporters.ipmi.port;
            in [
              {
                targets = ["localhost:${builtins.toString port}" "blue-fire:${builtins.toString port}"];
              }
            ];
          }

          {
            job_name = "idrac-exporter";
            static_configs = let
              port = config.services.prometheus.exporters.idrac.port;
            in [
              {
                targets = ["localhost:${builtins.toString port}"];
              }
            ];
          }

          {
            job_name = "chrony-exporter";
            static_configs = [
              {
                targets = ["localhost:${builtins.toString config.services.prometheus.exporters.chrony.port}"];
              }
            ];
          }
          {
            job_name = "coopi";
            static_configs = [
              {
                targets = ["coopi:9100"];
              }
            ];
          }
          {
            job_name = "ultrafeeder";
            static_configs = [
              {
                targets = ["enceladus:9273" "enceladus:9274"];
              }
            ];
          }
        ];
      };
    };
  };
}
