{lib, ...}: {
  imports = [./hardware-configuration.nix];

  config = {
    documentation.man.enable = true;
    time.hardwareClockInLocalTime = true;
    time.timeZone = "Europe/Amsterdam";

    networking = {
      networkmanager.enable = true;

      hostName = lib.mkDefault "wodan";

      firewall = {
        enable = false;
      };
      useDHCP = lib.mkDefault true;
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/usb-TOSHIBA_MK3263GSXN_111122223333-0:0";
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
