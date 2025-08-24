{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.lists) singleton;
in {
  config = let
    host = "terminus.harke.ma";
    port = "2300";
  in {
    services = {
      cloudflared = {
        enable = true;
        tunnels = {
          "69bc7708-5c7b-422d-b283-9199354f431f" = {
            ingress = {
              "${host}" = {
                service = "http://localhost:${port}";
              };
            };
          };
        };
      };

      postgresql = {
        enable = true;
        enableTCPIP = true;
        ensureDatabases = singleton "trmnl";
        ensureUsers = singleton {
          name = "trmnl";
          ensureDBOwnership = true;
        };
      };
    };

    virtualisation = {
      oci-containers.containers = {
        trmnl = {
          image = "ghcr.io/usetrmnl/terminus:latest";

          volumes = [
            "/var/lib/trmnl/web:/app/public/uploads:Z"
          ];

          environment = {
            RACK_ATTACK_ALLOWED_SUBNETS = "77.251.56.195";
            HANAMI_PORT = port;
            API_URI = "https://${host}";
            DATABASE_URL = "postgres://trmnl:trmnl@127.0.0.1:5432/trmnl";
          };

          extraOptions = [
            "--network=host"
          ];
          autoStart = true;
        };
      };
    };
  };
}
