{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.apps.attic-server;
in {
  options.apps.attic-server = {
    enable = mkEnableOption "attic-server";
  };

  config = mkIf cfg.enable {
    proxy-services.services = {
      "/attic" = {
        proxyPass = "http://localhost:8080/";
        extraConfig = ''
          rewrite /attic(.*) $1 break;
        '';
      };
    };

    services.atticd = {
      enable = true;

      credentialsFile = "/etc/atticd.env";

      storage = {
        # Storage type
        #
        # Can be "local" or "s3".
        type = "s3";

        # ## Local storage

        # The directory to store all files under
        # path = "/data"

        # ## S3 Storage (set type to "s3" and uncomment below)

        # The AWS region
        #region = "us-east-1"

        # The name of the bucket
        bucket = "attic";

        # Custom S3 endpoint
        #
        # Set this if you are using an S3-compatible object storage (e.g., Minio).
        endpoint = "https://cce1d3af687f672684f23cf7aa7731f7.r2.cloudflarestorage.com/";
      };

      settings = {
        listen = "0.0.0.0:8080";
        api-endpoint = "https://blue-fire.ling-lizard.ts.net/attic/";
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
        garbage-collecting = {
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
