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
      # binfmt.emulatedSystems = ["aarch64-linux"];
      initrd.kernelModules = ["nvidia"];
      extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
      # kernelPackages = pkgs.linuxPackages;
    };

    environment.variables = {
      WLR_RENDERER = "vulkan sway";
    };

    hardware.opengl.extraPackages = with pkgs; [
      # trying to fix `WLR_RENDERER=vulkan sway`
      vulkan-validation-layers
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
    fileSystems."/mnt/media" = {
      device = "192.168.0.11:/export/media";
      fsType = "nfs";
    };
    resilio.enable = lib.mkForce false;

    networking.interfaces."enp2s0".mtu = 9000;

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
      main = "/dev/disk/by-id/usb-CT120BX5_00SSD1_111122223333-0:0";
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
