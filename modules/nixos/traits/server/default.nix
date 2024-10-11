{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.traits.server;
in {
  options.traits.server = {
    enable = lib.mkEnableOption "server";

    headless.enable = lib.mkEnableOption "server headless";
  };

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["server"];

    services = {
      hypervisor = {
        enable = true;
        webservices.enable = true;
      };
      vscode-server = {
        enable = true;
        # socketPath = "/run/openvscode/socket";
        # connectionTokenFile = "/var/lib/openvscode/token";
      };
    };

    # chaotic = {
    #   scx.enable = mkForce false;
    # };

    hardware = {
      nvidia = {
        nvidiaPersistenced = false;
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
