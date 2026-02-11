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
      openvscode-server = {
        enable = true;
        host = "0.0.0.0";
        port = 3333;
        user = "tomas";
      };
      vscode-server = {
        enable = true;
        enableFHS = false;
        installPath = [
          "$HOME/.vscode-server"
          "$HOME/.vscode-server-oss"
          "$HOME/.vscode-server-insiders"
        ];
      };
    };

    disks.btrfs.swap.resume.enable = false;

    hardware = {
      nvidia = {
        # nvidiaPersistenced = true;
      };
    };

    apps.docker.enable = true;
    traits.server.headless.enable = true;
    boot = {
      tmp = {
        useTmpfs = true;
      };
      kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-server;
      # kernelPackages = pkgs.linuxPackages_6_12;
    };
  };
}
