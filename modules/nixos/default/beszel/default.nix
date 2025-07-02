{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.services.beszel;
in {
  options.services.beszel = {
    enable = lib.mkEnableOption "beszel" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    apps.docker.enable = true;

    virtualisation.oci-containers.containers = {
      beszel-agent = {
        image = "henrygd/beszel-agent";

        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];

        extraOptions = [
          "--privileged"
          "--net=host"
        ];

        environment = {
          PORT = "45876";
          KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBb6gQ1tX2NulWR+f3X8oMSQsh0Is55vpaa8xxbU7Ay";
        };

        autoStart = true;
      };
    };
  };
}
