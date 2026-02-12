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
            pull = "always";
            # imageFile = pkgs.dockerTools.pullImage {
            #   imageName = "crazymax/diun";
            #   imageDigest = "sha256:3e277cd1f1262fe6ff1047e5550f6f2e1c860c3c60b0058625e3c69888a4cc8d";
            #   hash = "sha256-FPSuEgnZiGITSmq4UxE6INDKv9jdI1h+5Hv1nuJJCkc=";
            #   finalImageName = "crazymax/diun";
            #   finalImageTag = "latest";
            # };

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
        liveRestore = true;

        autoPrune = {
          enable = true;
          dates = "weekly";
          persistent = true;
          randomizedDelaySec = "45min";
        };

        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    };
  };
}
