{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.atticd;
in {
  options.apps.atticd = {
    enable = lib.mkEnableOption "atticd";
  };

  config = lib.mkIf cfg.enable {
    services.atticd = {
      enable = true;
      environmentFile = "/srv/atticd/env-file";
      settings = {
        listen = "[::]:7124";

        # api-endpoint = "https://nix.harke.ma/";

        api-endpoint = "http://${config.networking.hostName}.ling-lizard.ts.net:7124/";
        database = {url = "sqlite:///srv/atticd/db/server.db?mode=rwc";};
        # File storage configuration
        storage = {
          # Storage type
          #
          # Can be "local" or "s3".
          type = "local";

          # ## Local storage

          # The directory to store all files under
          path = "/srv/atticd/storage";
        };

        # Warning: If you change any of the values here, it will be
        # difficult to reuse existing chunks for newly-uploaded NARs
        # since the cutpoints will be different. As a result, the
        # deduplication ratio will suffer for a while after the change.
        chunking = {
          # The minimum NAR size to trigger chunking
          #
          # If 0, chunking is disabled entirely for newly-uploaded NARs.
          # If 1, all NARs are chunked.
          nar-size-threshold = 65536; # chunk files that are 64 KiB or larger

          # The preferred minimum size of a chunk, in bytes
          min-size = 16384; # 16 KiB

          # The preferred average size of a chunk, in bytes
          avg-size = 65536; # 64 KiB

          # The preferred maximum size of a chunk, in bytes
          max-size = 262144; # 256 KiB
        };
        # Compression
        compression = {
          # Compression type
          #
          # Can be "none", "brotli", "zstd", or "xz"
          type = "zstd";

          # Compression level
          level = 9;
        };

        # Garbage collection
        garbage-collection = {
          # The frequency to run garbage collection at
          #
          # By default it's 12 hours. You can use natural language
          # to specify the interval, like "1 day".
          #
          # If zero, automatic garbage collection is disabled, but
          # it can still be run manually with `atticd --mode garbage-collector-once`.
          interval = "12 hours";

          # Default retention period
          #
          # Zero (default) means time-based garbage-collection is
          # disabled by default. You can enable it on a per-cache basis.
          #default-retention-period = "6 months"
        };
        # jwt = {
        # JWT RS256 secret key
        #
        # Set this to the base64-encoded private half of an RSA PEM PKCS1 key.
        # You can also set it via the `ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64`
        # environment variable.
        # token-rs256-secret-base64 = "ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64";
        # };
      };
    };
  };
}
