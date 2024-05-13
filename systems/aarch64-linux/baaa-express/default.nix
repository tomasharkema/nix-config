{ pkgs, inputs, lib, ... }:
with lib; {
  # imports = with inputs; [
  # nixos-hardware.nixosModules.raspberry-pi-4
  # ];

  config = {
    networking.hostName = "baaa-express";

    traits.raspberry.enable = true;

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
    boot = {
      blacklistedKernelModules = [ "pcie_brcmstb" ];

      loader = {
        generic-extlinux-compatible.enable = true;

        # start_x=1

        raspberryPi.firmwareConfig = ''
          force_turbo=1
          gpu_mem=256
          cma=320M
        '';
      };
      # initrd.kernelModules = ["vc4" "bcm2835_dma" "i2c_bcm2835"];
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

      # kernelParams = [
      # "console=ttyS1,115200n8"
      # "cma=320M"
      # ];
    };

    hardware = {
      enableRedistributableFirmware = true;
      i2c.enable = true;

      # raspberry-pi."4" = {
      #   apply-overlays-dtmerge.enable = true;
      #   dwc2 = {
      #     enable = true;
      #     dr_mode = "peripheral";
      #   };
      # };

      deviceTree = {
        enable = true;
        filter = "bcm2710-rpi-3-b-plus.dtb";
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
