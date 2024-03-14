{
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; {
  config = {
    networking.hostName = "baaa-express";

    traits.raspberry.enable = true;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];

    services = {
      netdata.enable = mkForce false;
    };
    # system.stateVersion = "23.11";

    # fileSystems."/".fsType = lib.mkForce "tmpfs";
    # fileSystems."/".device = lib.mkForce "none";

    boot = {
      initrd.availableKernelModules = ["vc4" "bcm2835_dma" "i2c_bcm2835"];
      initrd.kernelModules = ["dwc2" "g_serial"];

      kernelPackages = pkgs.linuxPackages_rpi4;

      kernelParams = [
        "console=ttyS1,115200n8"
        "cma=320M"
      ];

      loader.raspberryPi = {
        enable = true;
        version = 3;
        #     core_freq=250
        firmwareConfig = ''
          dtoverlay=dwc2
        '';
        # uboot.enable = true;
      };
    };
    hardware = {
      i2c.enable = true;

      #      raspberry-pi."4" = {
      #        apply-overlays-dtmerge.enable = true;
      #        dwc2 = {
      #          enable = true;
      #          dr_mode = "peripheral";
      #};
      #  };

      #   deviceTree = {
      #      enable = true;
      #       filter = "*rpi-3-b-*.dtb";
      #      };
    };
    # systemd.services.btattach = {
    #   before = ["bluetooth.service"];
    #   after = ["dev-ttyAMA0.device"];
    #   wantedBy = ["multi-user.target"];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
    #   };
    # };
  };
}
