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

    # services.resolved.enable = true;

    virtualisation = {
      oci-containers.backend = "podman";

      containers.enable = true;

      podman = {
        enable = true;

        dockerCompat = true;
        dockerSocket.enable = true;

        enableNvidia = config.trait.hardware.nvidia.enable;

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
