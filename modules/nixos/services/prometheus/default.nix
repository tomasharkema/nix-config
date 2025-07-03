{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.prometheus;
  format = pkgs.formats.yaml {};
in {
  options.apps.prometheus = {
    enable = lib.mkEnableOption "prometheus" // {default = true;};

    server.enable = lib.mkEnableOption "prometheus server";
  };

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["prometheus"];

    # age.secrets."promtail".rekeyFile = ./promtail.age;
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

    # systemd = {
    #   tmpfiles.settings."9-promtail" = {
    #     "/var/lib/promtail".d = {
    #       mode = "0777";
    #       user = "root";
    #       group = "root";
    #     };
    #   };
    # };

    services = {
      prometheus = {
        exporters = {
          chrony.enable = true;
          node = {
            enable = true;
            enabledCollectors = ["systemd" "textfile" "arp"];
            # disabledCollectors = ["arp"];

            extraFlags = [
              "--collector.textfile.directory=/var/lib/prometheus-node-exporter-text-files"
            ];
          };

          process.enable = true;

          nginx = {enable = true;};

          systemd.enable = true;

          smartctl.enable = true;
        };
      };

      netdata.configDir."go.d/prometheus.conf" = format.generate "prometheus.conf" {
        jobs =
          []
          ++ (lib.optional config.services.prometheus.exporters.node.enable {
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
  };
}
