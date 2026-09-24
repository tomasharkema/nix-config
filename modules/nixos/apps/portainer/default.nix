{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.services.portainer;
in {
  options.services.portainer = {
    enable = lib.mkEnableOption "portainer";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      portainer = {
        image = "portainer/portainer-ce:lts";
        pull = "always";

        autoStart = true;

        ports = [
          "9443:9443"
          "8000:8000"
        ];

        volumes = [
          "/var/lib/portainer:/data"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
      };
    };
  };
}
