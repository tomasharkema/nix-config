{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.docker;
in {
  options.apps.docker = {enable = lib.mkEnableOption "enable docker";};

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["docker"];

    environment.systemPackages = with pkgs; [
      dive
      docker-compose
      nerdctl
      lazydocker
      dry
    ];

    virtualisation = {
      oci-containers = {
        backend = "docker";

        containers = {
          wud = lib.mkIf true {
            image = "ghcr.io/getwud/wud";

            autoStart = true;
            ports = ["3010:3000"];
            volumes = [
              "/var/run/docker.sock:/var/run/docker.sock"
            ];
          };
        };
      };

      docker = {
        enable = true;
        enableOnBoot = true;
        storageDriver = "overlay2";
        # daemon.settings.pruning = {
        #   enabled = true;
        #   interval = "24h";
        # };
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    };
  };
}
