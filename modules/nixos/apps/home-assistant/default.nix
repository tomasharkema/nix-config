{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.home-assistant;
in {
  options.apps.home-assistant = {enable = lib.mkEnableOption "home-assistant";};

  config = lib.mkIf cfg.enable {
    apps.podman.enable = true;

    virtualisation = {
      oci-containers.containers = {
        home-assistant = {
          image = "ghcr.io/home-assistant/home-assistant:stable";

          autoStart = true;
          extraOptions = ["--privileged" "--network=host"];
          volumes = ["/run/dbus:/run/dbus:ro" "/var/lib/home-assistant:/config:Z"];
        };
      };
    };
  };
}
