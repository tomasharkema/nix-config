{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.apps.attic-server;
  port = 5000;
in {
  options.apps.attic-server = { enable = mkEnableOption "attic-server"; };

  config = mkIf (cfg.enable && false) {
    proxy-services.services = {
      # "/attic" = {
      #   proxyPass = "http://localhost:${builtins.toString port}";
      #   extraConfig = ''
      #     client_max_body_size 10G;
      #     rewrite /attic(.*) $1 break;
      #   '';
      # };
      "/attic" = {
        # proxyPass = "http://localhost:${builtins.toString port}";
        extraConfig = ''
          # client_max_body_size 10G;
          rewrite /attic(.*) https://nix-cache.harke.ma$1;
          return 301;
        '';
      };
    };

    services.postgresql = mkIf false {
      enable = true;

      enableTCPIP = true;
      port = 5432;

      identMap = ''
        atticd-users atticd atticd
        atticd-users root atticd
        # The postgres user is used to create the pg_trgm extension for the hydra database
        atticd-users postgres postgres
      '';

      authentication = ''
        #type database  DBuser  auth-method
        host  all       all     127.0.0.1/32 trust
        host  all       all     100.0.0.0/8 trust
        local atticd    all     ident map=atticd-users
      '';

      initialScript = pkgs.writeText "backend-initScript-atticd" ''
        CREATE ROLE atticd WITH LOGIN PASSWORD 'atticd' CREATEDB;
        CREATE DATABASE atticd;
        GRANT ALL PRIVILEGES ON DATABASE atticd TO atticd;
      '';
    };

    networking.firewall.allowedTCPPorts = mkIf false [ port ];

    services.atticd = mkIf false {
      enable = true;

      credentialsFile = "/etc/atticd.env";

      settings = {
        listen = "0.0.0.0:${builtins.toString port}";
        api-endpoint = "https://blue-fire.ling-lizard.ts.net/attic/";

        database = {
          # url = "postgresql:///atticd?host=/run/postgresql&user=atticd";
          url = "postgresql://atticd:@127.0.0.1/atticd";
        };

        # storage = {
        #   # Storage type
        #   #
        #   # Can be "local" or "s3".
        #   type = "s3";

        #   # ## Local storage

        #   # The directory to store all files under
        #   # path = "/data"

        #   # ## S3 Storage (set type to "s3" and uncomment below)

        #   # The AWS region
        #   region = "us-east-1";

        #   # The name of the bucket
        #   bucket = "attic";

        #   # Custom S3 endpoint
        #   #
        #   # Set this if you are using an S3-compatible object storage (e.g., Minio).
        #   endpoint = "https://cce1d3af687f672684f23cf7aa7731f7.r2.cloudflarestorage.com/";
        # };

        compression = {
          # Can be "none", "brotli", "zstd", or "xz"
          type = "zstd";

          # Compression level
          level = 8;
        };
        chunking = {
          # The minimum NAR size to trigger chunking
          #
          # If 0, chunking is disabled entirely for newly-uploaded NARs.
          # If 1, all NARs are chunked.
          nar-size-threshold = 64 * 1024; # 64 KiB

          # The preferred minimum size of a chunk, in bytes
          min-size = 16 * 1024; # 16 KiB

          # The preferred average size of a chunk, in bytes
          avg-size = 64 * 1024; # 64 KiB

          # The preferred maximum size of a chunk, in bytes
          max-size = 256 * 1024; # 256 KiB
        };
        garbage-collection = {
          # The frequency to run garbage collection at
          #
          # By default it's 12 hours. You can use natural language
          # to specify the interval, like "1 day".
          #
          # If zero, automatic garbage collection is disabled, but
          # it can still be run manually with `atticd --mode garbage-collector-once`.
          interval = "1 day";

          # Default retention period
          #
          # Zero (default) means time-based garbage-collection is
          # disabled by default. You can enable it on a per-cache basis.
          default-retention-period = "14 days";
        };
      };
    };
  };
}
