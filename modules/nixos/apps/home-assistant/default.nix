{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.home-assistant;
in {
  options.apps.home-assistant = {
    enable = lib.mkEnableOption "home-assistant";
    folder = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/home-assistant";
    };
  };

  config = lib.mkIf cfg.enable {
    apps.podman.enable = true;

    systemd.tmpfiles.rules = ["d ${cfg.folder} 0777 root root -"];

    virtualisation = {
      oci-containers.containers = {
        home-assistant = {
          image = "ghcr.io/home-assistant/home-assistant:stable";

          autoStart = true;
          extraOptions = ["--privileged" "--network=host"];
          volumes = ["/run/dbus:/run/dbus:ro" "${cfg.folder}:/config:Z"];
        };
      };
    };
  };
}
