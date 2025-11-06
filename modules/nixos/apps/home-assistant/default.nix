{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.hass;
in {
  options.apps.hass = {
    enable = lib.mkEnableOption "hass";
    folder = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/home-assistant";
    };
  };

  config = lib.mkIf cfg.enable {
    apps.docker.enable = true;

    services.tsnsrv.services = {
      hass = {
        toURL = "http://127.0.0.1:8123";
        upstreamHeaders = {
          Host = "hass.ling-lizard.ts.net";
        };
      };
    };

    virtualisation = {
      oci-containers.containers = {
        home-assistant = {
          image = "ghcr.io/home-assistant/home-assistant:stable";

          autoStart = true;

          extraOptions = ["--privileged" "--network=host"];

          volumes = [
            "/run/dbus:/run/dbus:ro"
            "/etc/localtime:/etc/localtime:ro"
            "${cfg.folder}:/config"
          ];
        };
      };
    };
  };
}
