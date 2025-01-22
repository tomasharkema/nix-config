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
    assertions = [
      {
        assertion = !config.apps.podman.enable;
        message = "docker and podman cant be enabled both";
      }
    ];

    system.nixos.tags = ["docker"];
    environment.systemPackages = with pkgs; [
      dive
      docker-compose
      nerdctl
      lazydocker
    ];

    virtualisation = {
      oci-containers.backend = "docker";

      containers.enable = true;

      docker = {
        enable = true;
        enableOnBoot = true;
        storageDriver = "btrfs";
      };
    };
  };
}
