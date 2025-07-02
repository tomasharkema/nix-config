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
        partOf = ["docker.service"];
        after = ["docker.service"];
        requires = ["docker.service"];

        unitConfig = {
          ConditionPathExists = ["/etc/docker/compose/%i"];
        };

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          WorkingDirectory = "/etc/docker/compose/%i";
          ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d --remove-orphans";
          ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
        };
      };
    };
  };
}
