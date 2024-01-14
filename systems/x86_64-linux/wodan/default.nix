{lib, ...}: {
  imports = [./hardware-configuration.nix];

  config = {
    documentation.man.enable = false;

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
    };
    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/usb-TOSHIBA_MK3263GSXN_111122223333-0:0";
    };
    services.resilio = {
      enable = lib.mkForce false;
    };

    boot.loader = {
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        efiInstallAsRemovable = true;
      };
    };
  };
}
