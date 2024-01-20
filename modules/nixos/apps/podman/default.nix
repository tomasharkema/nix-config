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

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;

        autoPrune.enable = true;
        # networkSocket.enable = true;
      };
      oci-containers.backend = "podman";
    };
  };
}
