{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    services.promtail = {
      enable = true;
      extraFlags = ["--config.expand-env=true"];
      configuration = {
        server = {
          http_listen_port = 0;
          grpc_listen_port = 0;
        };
        positions = {filename = "/var/lib/promtail/positions.yaml";};

        clients = [
          {url = "http://silver-star.ling-lizard.ts.net:3100/loki/api/v1/push";}
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
    };
  };
}
