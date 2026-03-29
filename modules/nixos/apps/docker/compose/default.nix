{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.apps.docker.enable {
    systemd.services = {
      "docker-compose@" = {
        overrideStrategy = "asDropin";
        wantedBy = ["multi-user.target"];
        description = "%i service with docker compose";

        after = ["docker.service" "docker.socket" "network-online.target"];
        wants = ["network-online.target"];

        unitConfig = {
          ConditionPathExists = ["/etc/docker/compose/%i"];
        };

        serviceConfig = {
          Type = "simple";
          WorkingDirectory = "/etc/docker/compose/%i";
          ExecStart = "${pkgs.docker-compose}/bin/docker-compose up";
          ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
        };
      };
    };
  };
}
