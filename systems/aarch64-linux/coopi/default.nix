{
  pkgs,
  inputs,
  lib,
  ...
}: {
  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1YWKTdedduXBRefDk2melpN4UlkYZLi95xEY+jcni2 root@nixos";
    };

    hardware = {
      enableRedistributableFirmware = true;
      i2c.enable = true;

      deviceTree = {
        enable = true;
        filter = "*rpi*.dtb";

        overlays = [
          {
            name = "ina219";
            dtsFile = ./i2c-ina219.dts;
          }
        ];
      };
    };

    networking = {
      hostName = "coopi";
      firewall.enable = false;
      networkmanager.enable = true;
    };

    zramSwap = {enable = true;};

    swapDevices = [
      {
        device = "/swapfile";
        size = 16 * 1024;
      }
    ];

    traits = {
      raspberry.enable = true;
      low-power.enable = true;
      hardware.bluetooth.enable = true;
    };
  };
}
