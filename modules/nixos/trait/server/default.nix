{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.trait.server;
in {
  options.trait.server = {
    enable = mkEnableOption "server";
  };
  config = mkIf cfg.enable {
    services = {
      hypervisor = {
        webservices.enable = true;
      };
    };

    apps.podman.enable = true;

    boot = {
      tmp = {
        useTmpfs = true;
      };
    };
  };
}
