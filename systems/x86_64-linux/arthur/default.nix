{
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; {
  imports = with inputs; [
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
    # (pkgs.modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
  ];

  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNjMAH00cvtgNj1+5bMhUi0woJJ5kmhu1o2h2AmzRJW root@arthur";
    };

    nixpkgs.config.rocmSupport = true;

    gui = {
      # enable = true;
      # desktop = {
      #   rdp.enable = true;
      # };
      #   apps.steam.enable = true;

      icewm.enable = true;
    };

    environment.systemPackages = with pkgs; [custom.elxflash];

    trait = {
      server.enable = true;
      builder.enable = true;
      hardware = {
        # tpm.enable = true;
        # secure-boot.enable = true;
        remote-unlock.enable = true;
      };
    };

    services = {
      # freeipa.replica.enable = true;
      tcsd.enable = true;
      xserver.videoDrivers = ["amdgpu"];
    };

    apps = {
      home-assistant.enable = true;
      podman.enable = true;
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-Samsung_SSD_850_PRO_256GB_S39KNX0J775697K";
      media = "/dev/disk/by-id/ata-ST2000DX001-1CM164_Z1E99G1N";
      encrypt = true;
      newSubvolumes = true;
      swap = false;
    };

    # resilio.root = "/mnt/media/resilio";

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];
      loader.systemd-boot.enable = true;
      initrd.kernelModules = ["amdgpu"];
    };

    hardware.graphics = {
      enable = true;

      enable32Bit = true;
      extraPackages = with pkgs; [amdvlk];
      extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
    };

    networking = {
      hostName = "arthur";
      hostId = "529fd7bb";
      useDHCP = false;
      interfaces."eno1" = {
        useDHCP = true;
        wakeOnLan.enable = true;
      };
      firewall.enable = true;
      wireless.enable = lib.mkForce false;
    };

    services.hypervisor = {
      enable = true;
      bridgeInterfaces = ["eno1"];
    };
  };
}
