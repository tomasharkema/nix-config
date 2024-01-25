{lib, ...}: {
  imports = [./hardware-configuration.nix];

  config = {
    documentation.man.enable = false;

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];
    };

    time = {
      hardwareClockInLocalTime = true;
      timeZone = "Europe/Amsterdam";
    };

    hardware.opengl.enable = true;

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
      game-mode.enable = true;
      quiet-boot.enable = true;
      apps.flatpak.enable = true;
    };

    services.thermald.enable = true;
resilio.enable = lib.mkForce false;
    traits = {
      hardware = {
        tpm.enable = true;
        # secure-boot.enable = true;
        nvidia.enable = true;
      };
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/usb-CT120BX5_00SSD1_111122223333-0:0";
      encrypt = true;
    };

    boot = {
      loader = {
        efi = {
          canTouchEfiVariables = false;
          # efiSysMountPoint = "/boot";
        };
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          efiInstallAsRemovable = true;
        };
      };
    };
  };
}
