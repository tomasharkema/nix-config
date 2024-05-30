{ config, pkgs, lib, ... }:
with lib;
with lib.custom;
let cfg = config.prometheus;
in {
  options.prometheus = {
    enable = mkBoolOpt true "SnowflakeOS GNOME configuration";
  };

  config = mkIf cfg.enable {
    system.nixos.tags = [ "prometheus" ];
    services.promtail = lib.mkIf false {
      enable = false;
      configuration = {
        server = {
          http_listen_port = 3031;
          grpc_listen_port = 0;
        };
        positions = { filename = "/tmp/positions.yaml"; };
        clients = [{ url = "http://100.122.146.5:3100/loki/api/v1/push"; }];
        scrape_configs = [{
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = config.networking.hostName;
            };
          };
          relabel_configs = [{
            source_labels = [ "__journal__systemd_unit" ];
            target_label = "unit";
          }];
        }];
      };
      # extraFlags
    };

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

    services.prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" "textfile" ];
          disabledCollectors = [ "arp" ];

          extraFlags = [
            "--collector.textfile.directory=/var/lib/prometheus-node-exporter-text-files"
          ];
        };
        process.enable = true;
      };
    };
  };
}
