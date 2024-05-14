{ pkgs, inputs, lib, ... }:
with lib; {
  # imports = with inputs; [
  # nixos-hardware.nixosModules.raspberry-pi-4
  # ];

  config = {
    networking.hostName = "baaa-express";

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

    traits.low-power.enable = true;
    # traits.slim.enable = true;
    gui."media-center".enable = true;
    apps.spotifyd.enable = true;

    # system.stateVersion = "23.11";

    # fileSystems."/".fsType = lib.mkForce "tmpfs";
    # fileSystems."/".device = lib.mkForce "none";
    zramSwap = { enable = true; };
    swapDevices = [{
      device = "/swapfile";
      size = 16 * 1024;
    }];

    boot = {
      blacklistedKernelModules = [ "pcie_brcmstb" ];

      loader = {
        grub.enable = false;
        systemd-boot.enable = mkForce false;
        generic-extlinux-compatible.enable = mkDefault false;

        # start_x=1
        raspberryPi = {
          enable = true;
          version = 3;
          firmwareConfig = ''
            force_turbo=1
            gpu_mem=256
            cma=320M
          '';
        };
      };

      initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];
      initrd.availableKernelModules = mkForce [
        "ext2"
        "ext4"
        "sd_mod"
        "sr_mod"
        "ehci_hcd"
        "ohci_hcd"
        "xhci_hcd"
        "usbhid"
        "hid_generic"
        "hid_lenovo"
        "hid_apple"
        "hid_roccat"
        "hid_logitech_hidpp"
        "hid_logitech_dj"
        "hid_microsoft"
        "hid_cherry"
        "hid_corsair"
      ];
      # initrd.kernelModules = ["dwc2" "g_serial"];

      # kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;
      kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;

      # kernelPackages = pkgs.linuxPackages_latest;

      kernelParams = [ "console=ttyS1,115200n8" "cma=320M" ];
    };

    hardware = {
      enableRedistributableFirmware = true;
      i2c.enable = true;

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
