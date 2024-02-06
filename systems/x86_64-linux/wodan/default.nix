{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  config = {
    # hardware.nvidia.forceFullCompositionPipeline = true;
    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];
      initrd.kernelModules = ["nvidia"];
      # extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
      # kernelPackages = pkgs.linuxPackages;boot.
      supportedFilesystems = ["ntfs"];
    };

    # environment.variables = {
    #   NIXOS_OZONE_WL = "1";
    # };

    # environment.sessionVariables = {
    #   NIXOS_OZONE_WL = "1";
    # };

    environment.systemPackages = with pkgs; [rclone rclone-browser];

    services.hardware.openrgb.enable = true;

    hardware.opengl.extraPackages = with pkgs; [
      # trying to fix `WLR_RENDERER=vulkan sway`
      vulkan-validation-layers
      openrgb-with-all-plugins
    ];

    time = {
      hardwareClockInLocalTime = true;
      timeZone = "Europe/Amsterdam";
    };

    networking = {
      networkmanager.enable = true;

      hostName = lib.mkDefault "wodan";

      firewall = {
        enable = false;
      };
      useDHCP = lib.mkDefault true;
    };
    gui = {
      enable = true;
      desktop = {
        enable = true;
        rdp.enable = true;
      };
      apps.steam.enable = true;
      game-mode.enable = false;
      quiet-boot.enable = true;
      apps.flatpak.enable = true;
    };
    # fileSystems."/mnt/media" = {
    #   device = "192.168.0.11:/export/media";
    #   fsType = "nfs";
    # };
    services.udev.packages = [pkgs.openrgb];
    boot.kernelModules = ["i2c-dev"];
    hardware.i2c.enable = true;
    headless.hypervisor.enable = true;
    services.command-center = {
      enableBot = true;
    };

    networking.interfaces."enp2s0".mtu = 9000;

    fileSystems."/mnt/unraid/appdata" = {
      device = "192.168.0.100:/mnt/user/appdata";
      fsType = "nfs";
    };
    fileSystems."/mnt/unraid/appdata_ssd" = {
      device = "192.168.0.100:/mnt/user/appdata_ssd";
      fsType = "nfs";
    };
    fileSystems."/mnt/unraid/appdata_disk" = {
      device = "192.168.0.100:/mnt/user/appdata_disk";
      fsType = "nfs";
    };
    fileSystems."/mnt/dione" = {
      device = "192.168.178.3:/volume1/homes";
      fsType = "nfs";
    };

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        nvidia.enable = true;
        remote-unlock.enable = true;
      };
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B768639292E";
      encrypt = true;
    };

    # boot = {
    #   loader = {
    #     efi = {
    #       canTouchEfiVariables = false;
    #       # efiSysMountPoint = "/boot";
    #     };
    #     grub = {
    #       enable = true;
    #       efiSupport = true;
    #       device = "nodev";
    #       efiInstallAsRemovable = true;
    #     };
    #   };
    # };
  };
}
