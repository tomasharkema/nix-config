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

    environment.etc."distrobox/distrobox.conf".text = ''
      container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
    '';

    virtualisation = {
      oci-containers = {
        backend = "docker";

        containers = {
          duin = {
            image = "crazymax/diun:latest";

            autoStart = true;
            cmd = ["serve"];
            environment = {
              TZ = "Europe/Amsterdam";
              DIUN_WATCH_WORKERS = "20";
              DIUN_WATCH_SCHEDULE = "0 */6 * * *";
              DIUN_WATCH_JITTER = "30s";
              DIUN_PROVIDERS_DOCKER = "true";
              DIUN_NOTIF_NTFY_TOPIC = "tomasharkema-nixos";
            };

            volumes = [
              "/var/lib/diun:/data"
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
        # rootless = {
        #   enable = true;
        #   setSocketVariable = true;
        # };
      };
    };
  };
}
