{
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; {
  imports = with inputs; [
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  config = {
    networking.hostName = "baaa-express";

    traits.raspberry.enable = true;

    sound.extraConfig = ''
      defaults.pcm.!card 1
    '';

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];

    traits.low-power.enable = true;
    traits.slim.enable = true;
    gui."media-center".enable = true;
    apps.spotifyd.enable = true;

    # system.stateVersion = "23.11";

    # fileSystems."/".fsType = lib.mkForce "tmpfs";
    # fileSystems."/".device = lib.mkForce "none";
    boot = {
      loader = {
        generic-extlinux-compatible.enable = true;
        raspberryPi.firmwareConfig = ''
          force_turbo=1
          start_x=1
          gpu_mem=256
          cma=320M
        '';
      };
      initrd.kernelModules = ["vc4" "bcm2835_dma" "i2c_bcm2835"];
      # initrd.availableKernelModules = mkForce [
      #   "vc4"
      #   "bcm2835_dma"
      #   "i2c_bcm2835"
      #   "usbhid"
      #   "usb_storage"
      #   "vc4"
      #   # "pcie_brcmstb"
      #   "reset-raspberrypi"
      #   "ext2"
      #   "ext4"
      #   # "ahci"
      #   # "sata_nv"
      #   # "sata_via"
      #   # "sata_sis"
      #   # "sata_uli"
      #   # "ata_piix"
      #   # "pata_marvell"
      #   # "nvme"
      #   "sd_mod"
      #   "sr_mod"
      #   "mmc_block"
      #   # "uhci_hcd"
      #   # "ehci_hcd"
      #   # "ehci_pci"
      #   # "ohci_hcd"
      #   # "ohci_pci"
      #   # "xhci_hcd"
      #   # "xhci_pci"
      #   "usbhid"
      #   # "hid_generic"
      #   # "hid_lenovo"
      #   # "hid_apple"
      #   # "hid_roccat"
      #   # "hid_logitech_hidpp"
      #   # "hid_logitech_dj"
      #   # "hid_microsoft"
      #   # "hid_cherry"
      # ];
      # initrd.kernelModules = ["dwc2" "g_serial"];

      # kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;
      # kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;

      kernelPackages = pkgs.linuxPackages_latest;

      # kernelParams = [
      # "console=ttyS1,115200n8"
      # "cma=320M"
      # ];
    };

    hardware = {
      enableRedistributableFirmware = true;
      i2c.enable = true;

      raspberry-pi."4" = {
        apply-overlays-dtmerge.enable = true;
        dwc2 = {
          enable = true;
          dr_mode = "peripheral";
        };
      };

      deviceTree = {
        enable = true;
        filter = "*rpi-3-*.dtb";
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
