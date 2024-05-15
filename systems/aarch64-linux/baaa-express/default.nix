{ pkgs, inputs, lib, ... }:
with lib; {
  # imports = with inputs; [
  # nixos-hardware.nixosModules.raspberry-pi-4
  # ];

  config = {
    networking = {
      firewall.enable = false;
      hostName = "baaa-express";
      networkmanager.enable = true;
    };

    fileSystems = {
      # "/boot" = {
      #   device = "/dev/disk/by-label/NIXOS_BOOT";
      #   fsType = "vfat";
      # };
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };
    };
    # traits.raspberry.enable = true;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];

    traits = {
      low-power.enable = true;
      hardware = { bluetooth.enable = true; };
    };
    # traits.slim.enable = true;

    gui."media-center".enable = true;

    apps = {
      spotifyd.enable = true;
      cec.enable = true;
      unified-remote.enable = true;
    };

    services = {
      cage.enable = false;

      avahi = {
        enable = true;
        allowInterfaces = mkForce null;
      };
    };

    # system.stateVersion = "23.11";

    # fileSystems."/".fsType = lib.mkForce "tmpfs";
    # fileSystems."/".device = lib.mkForce "none";
    zramSwap = { enable = true; };
    swapDevices = [{
      device = "/swapfile";
      size = 16 * 1024;
    }];

    programs.atop = {
      enable = mkForce false;
      netatop.enable = false;
    };

    boot = {

      loader = {
        grub.enable = lib.mkDefault false;
        generic-extlinux-compatible.enable = lib.mkDefault true;
      };

      initrd.kernelModules =
        [ "vc4" "bcm2835_dma" "i2c_bcm2835" "dwc2" "g_serial" ];
      # initrd.availableKernelModules = mkForce [
      #   "ext2"
      #   "ext4"
      #   "sd_mod"
      #   "sr_mod"
      #   "ehci_hcd"
      #   "ohci_hcd"
      #   "xhci_hcd"
      #   "usbhid"
      #   "hid_generic"
      #   "hid_lenovo"
      #   "hid_apple"
      #   "hid_roccat"
      #   "hid_logitech_hidpp"
      #   "hid_logitech_dj"
      #   "hid_microsoft"
      #   "hid_cherry"
      #   "hid_corsair"
      # ];

      # kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;
      kernelPackages = pkgs.linuxPackages_latest;

      kernelParams = [
        # "console=ttyS0,115200n8"
        "console=ttyS1,115200n8"
        "cma=320M"
        "otg_mode=1"
      ];
    };

    hardware = {
      enableRedistributableFirmware = true;
      i2c.enable = true;

      deviceTree = let drMode = "otg";
      in {
        filter = lib.mkDefault "*rpi-3-b.dtb";
        enable = true;

        overlays = [{
          name = "dwc2";
          dtboFile =
            "${pkgs.raspberrypifw}/share/raspberrypi/boot/overlays/dwc2.dtbo";
        }];
      };
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
