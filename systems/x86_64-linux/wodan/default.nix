{lib, ...}: {
  imports = [./hardware-configuration.nix];

  config = {
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
        # canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
      };
    };
  };
}
