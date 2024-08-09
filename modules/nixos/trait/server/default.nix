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

    headless.enable = mkEnableOption "server headless";
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["server"];
    services = {
      hypervisor = {
        enable = true;
        webservices.enable = true;
      };
    };

    virtualisation.virtualbox.host = {
      headless = true;
      enableWebService = true;
    };

    apps.podman.enable = true;

    boot = {
      tmp = {
        useTmpfs = true;
      };
    };
  };
}
