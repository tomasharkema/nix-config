{
  lib,
  config,
  ...
}: let
  cfg = config.services.netbootxyz;
in {
  options.services.netbootxyz = {
    enable = lib.mkEnableOption "netbootxyz";
  };

  config = lib.mkIf cfg.enable {
    apps.docker.enable = true;

    virtualisation.oci-containers.containers = {
      netbootxyz = {
        image = "linuxserver/netbootxyz:0.7.6";

        autoStart = true;

        volumes = [
          "/var/lib/netboot/config:/config"
          "/var/lib/netboot/assets:/assets"
        ];

        ports = [
          "3001:3000"
          "69:69/udp"
          "8083:80"
        ];
      };
    };
  };
}
