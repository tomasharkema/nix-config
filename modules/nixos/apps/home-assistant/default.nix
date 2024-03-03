{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.home-assistant;
in {
  options.apps.home-assistant = {
    enable = mkBoolOpt false "home-assistant";
  };

  config = mkIf cfg.enable {
    services.podman.enable = true;

    virtualisation = {
      oci-containers.containers = {
        home-assistant = {
          image = "ghcr.io/home-assistant/home-assistant:stable";

          autoStart = true;
          # extraOptions = [
          #   "--device=/dev/net/tun:/dev/net/tun"
          #   "--cap-add=NET_ADMIN"
          #   "--cap-add=NET_RAW"
          # ];
          volumes = [
            "/run/dbus:/run/dbus:ro"
            "/var/lib/home-assistant:/config:Z"
          ];
        };
      };
    };
  };
}
