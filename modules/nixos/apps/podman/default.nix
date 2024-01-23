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
