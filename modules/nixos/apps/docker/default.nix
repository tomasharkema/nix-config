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
          watchtower = lib.mkIf true {
            image = "containrrr/watchtower";

            autoStart = true;

            volumes = [
              "/var/run/docker.sock:/var/run/docker.sock"
            ];
          };
        };
      };

      # containers.enable = true;

      docker = {
        enable = true;
        enableOnBoot = true;
        storageDriver = "btrfs";

        # daemon.settings.features."containerd-snapshotter" = true;

        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    };
  };
}
