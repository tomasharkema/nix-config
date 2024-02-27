{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.podman;
in {
  options.services.podman = {
    enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["podman"];

    networking = {
      firewall = {
        trustedInterfaces = ["podman0"];
        #     interfaces.podman0.allowedUDPPorts = [53];
        #     enable = mkDefault false;
      };
    };

    virtualisation = {
      oci-containers.backend = "podman";

      podman = {
        enable = true;

        dockerCompat = true;

        enableNvidia = config.traits.hardware.nvidia.enable;
        defaultNetwork.settings.dns_enabled = true;

        # defaultNetwork.settings = {
        # dns_enabled = true;
        # ipam_options = {driver = "dhcp";};
        # };

        autoPrune.enable = true;
        # networkSocket.enable = true;
      };
    };
  };
}
