{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.apps.podman;
in {
  options.apps.podman = {enable = lib.mkEnableOption "enable podman";};

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["podman"];

    environment.systemPackages = with pkgs; [
      podman-tui
      dive
      docker-compose
      nerdctl
      # pods
    ];

    networking = {
      firewall = {
        interfaces."podman+" = {
          allowedUDPPorts = [53];
          allowedTCPPorts = [53];
        };
      };
    };

    # services.nix-snapshotter = {
    #   enable = true;
    # };

    # services.resolved.enable = true;

    systemd.services.podman.environment = {
      LOGGING = "--log-level=warn";
    };

    virtualisation = {
      oci-containers.backend = "podman";

      containers.enable = true;

      # containerd = {
      #   enable = true;
      #   nixSnapshotterIntegration = true;
      # };

      docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };

      podman = {
        enable = true;

        dockerCompat = true;
        dockerSocket.enable = true;

        enableNvidia = config.traits.hardware.nvidia.enable;

        defaultNetwork.settings.dns_enabled = true;
        # networkSocket = {
        #   enable = true;
        #   server = "ghostunnel";
        #   tls = {
        #     key = config.proxy-services.crt.key;
        #     cert = config.proxy-services.crt.crt;
        #   };
        # };
      };
    };
  };
}
