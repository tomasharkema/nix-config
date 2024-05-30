{ lib, config, ... }:
with lib;
with lib.custom;
let cfg = config.services.podman;
in {
  options.services.podman = { enable = mkBoolOpt false "enable podman"; };

  config = mkIf cfg.enable {
    system.nixos.tags = [ "podman" ];

    networking = {
      firewall = {
        interfaces."podman+" = {
          allowedUDPPorts = [ 53 ];
          allowedTCPPorts = [ 53 ];
        };
      };
    };

    # services.resolved.enable = true;

    virtualisation = {
      oci-containers.backend = "podman";

      podman = {
        enable = true;

        dockerCompat = true;
        dockerSocket.enable = true;

        enableNvidia = config.traits.hardware.nvidia.enable;

        defaultNetwork.settings.dns_enabled = true;

        autoPrune.enable = true;
        # networkSocket.enable = true;
      };
    };
  };
}
