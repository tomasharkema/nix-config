{ config, pkgs, lib, ... }:
with lib;
with lib.custom;
let cfg = config.apps.home-assistant;
in {
  options.apps.home-assistant = { enable = mkBoolOpt false "home-assistant"; };

  config = mkIf cfg.enable {
    apps.podman.enable = true;

    virtualisation = {
      oci-containers.containers = {
        home-assistant = {
          image = "ghcr.io/home-assistant/home-assistant:stable";

          autoStart = true;
          extraOptions = [ "--privileged" "--network=host" ];
          volumes =
            [ "/run/dbus:/run/dbus:ro" "/var/lib/home-assistant:/config:Z" ];
        };
      };
    };
  };
}
