{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.podman;
in {
  options.apps.podman = {
    enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["podman"];
    networking.firewall.trustedInterfaces = ["podman0"];

    networking.firewall.enable = false;

    virtualisation = {
      podman = {
        enable = true;

        dockerCompat = true;

        defaultNetwork.settings.dns_enabled = true;

        autoPrune.enable = true;
        # networkSocket.enable = true;
      };
      oci-containers.backend = "podman";
    };
  };
}
