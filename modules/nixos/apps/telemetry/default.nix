{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf false {
    systemd.services.opentelemetry-collector = {
      serviceConfig = {
        DynamicUser = lib.mkForce null;
        ProtectSystem = lib.mkForce null;
        DevicePolicy = lib.mkForce null;
        NoNewPrivileges = lib.mkForce null;
      };
    };

    services.opentelemetry-collector = {
      enable = true;
      package = pkgs.opentelemetry-collector-contrib;
      configFile = pkgs.writeText "otel.yml" ''
        receivers:
          journald:
          filelog/std:
            include: [ /var/log/**log ]
            # start_at: beginning
          hostmetrics:
            root_path: /
            collection_interval: 30s
            scrapers:
              cpu:
              disk:
              filesystem:
              load:
              memory:
              network:
              paging:
              processes:
              # process: # a bug in the process scraper causes the collector to throw errors so disabling it for now
        processors:
          resourcedetection/system:
            detectors: ["system"]
            system:
              hostname_sources: ["os"]
          memory_limiter:
            check_interval: 1s
            limit_percentage: 75
            spike_limit_percentage: 15
          batch:
            send_batch_size: 10000
            timeout: 10s

        extensions:
          zpages: {}
          memory_ballast:
            size_mib: 512

        exporters:
          otlphttp/openobserve:
            endpoint: http://silver-star:5080/api/default/
            headers:
              Authorization: "Basic dG9tYXNAaGFya2VtYS5pbzpQdXIxN0RCb21CZVd4U0xV"

        service:
          extensions: [zpages, memory_ballast]
          pipelines:
            metrics:
              receivers: [hostmetrics]
              processors: [resourcedetection/system, memory_limiter, batch]
              exporters: [otlphttp/openobserve]
            logs:
              receivers: [filelog/std, journald]
              processors: [resourcedetection/system, memory_limiter, batch]
              exporters: [otlphttp/openobserve]
      '';
    };
  };
}
