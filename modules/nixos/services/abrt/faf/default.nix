{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.services.abrt.server;
  package = pkgs.faf;

  folder = "/var/lib/faf";
  db-folder = "${folder}/db";
in {
  config = lib.mkIf (cfg.enable && false) {
    apps.podman.enable = true;

    systemd.tmpfiles.rules = [
      "d ${db-folder} 0600 root root -"
    ];

    virtualisation = {
      oci-containers.containers = {
        # podman run --pod faf-pod -v faf-volume:/var/lib/pgsql/data -e POSTGRESQL_ADMIN_PASSWORD=scrt --name db -dit quay.io/abrt/faf-db

        faf-db = {
          image = "quay.io/abrt/faf-db";
          autoStart = true;
          volumes = ["${db-folder}:/var/lib/pgsql/data:Z"];
          extraOptions = [
            "--name=faf-db"
            "--network=faf"
          ];
          environment = {
            POSTGRESQL_ADMIN_PASSWORD = "scrt";
          };
        };

        faf = {
          image = "quay.io/abrt/faf";
          ports = ["5432:5432" "6379:6379" "8080:8080"];
          autoStart = true;
          extraOptions = [
            "--network=faf"
          ];
          environment = {
            PGHOST = "faf-db";
            PGUSER = "faf";
            PGPASSWORD = "scrt";
            PGPORT = "5432";
            PGDATABASE = "faf";
          };
          # volumes = ["/run/dbus:/run/dbus:ro" "${cfg.folder}:/config:Z"];
        };
      };
    };
  };
}
