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
      # vscode-server = {
      # enable = true;
      # socketPath = "/run/openvscode/socket";
      # connectionTokenFile = "/var/lib/openvscode/token";
      # };
    };

    disks.btrfs.swap.resume.enable = false;

    hardware = {
      nvidia = {
        # nvidiaPersistenced = true;
      };
    };

    apps.docker.enable = true;

    boot = {
      tmp = {
        useTmpfs = true;
      };

      # kernelPackages = pkgs.linuxPackages_6_12;
      kernelPackages = pkgs.linuxPackages_cachyos-lts;

      initrd = {
        network = {
          enable = true;
          ssh = {
            enable = true;
            hostKeys = [
              "/etc/secrets/initrd/ssh_host_rsa_key"
              "/etc/secrets/initrd/ssh_host_ed25519_key"
              "/etc/secrets/initrd/ssh_host_ecdsa_key"
            ];
          };
          # flushBeforeStage2 = true;
        };
      };
    };
  };
}
