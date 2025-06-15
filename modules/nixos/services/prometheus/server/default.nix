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
      script = ''
        ${lib.getExe pkgs.custom.gpsd-exporter} -d 192.168.9.206:2947
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
      prometheus = {
        enable = true;
        pushgateway.enable = true;
        alertmanager-ntfy = {
          enable = true;
          settings = {
            ntfy = {
              baseurl = "https://ntfy.sh";
              notification.topic = "tomasharkema-nixos";
            };
          };
        };
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
                targets = ["192.168.9.155:9100"];
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
