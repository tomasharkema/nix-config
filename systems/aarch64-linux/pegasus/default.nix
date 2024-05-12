{
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; {
  imports = with inputs; [
    nixos-hardware.nixosModules.raspberry-pi-4
    # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
    # "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  config = {
    networking.hostName = "pegasus";

    virtualisation.vmVariant = {
      virtualisation = {
        diskSize = 50 * 1024;
        memorySize = 4 * 1024;
        cores = 4;
      };
    };

    zramSwap = {
      enable = true;
    };
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

    gui."media-center".enable = true;

    apps = {
      spotifyd.enable = true;
      cec.enable = true;
    };

    netdata.enable = mkForce true;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
      play-with-mpv
      open-in-mpv
      plex-mpv-shim
      mpv
      mpvc
      celluloid
    ];

    boot = {
      kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;

      initrd.availableKernelModules = [
        "xhci_pci"
        "usbhid"
        "usb_storage"
        #  "dwc2"
        "g_serial"
      ];
    };
    boot.kernelParams = lib.mkForce ["console=ttyS0,115200n8" "console=tty0"];

    hardware = {
      i2c.enable = true;

      bluetooth.package = pkgs.bluez;

      opengl = {
        enable = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
        ];
      };

      raspberry-pi."4" = {
        apply-overlays-dtmerge.enable = true;
        fkms-3d.enable = true;
        # dwc2 = {
        #   enable = true;
        #   dr_mode = "peripheral";
        # };
      };

      deviceTree = {
        enable = true;
        filter = mkForce "*rpi-4-*.dtb";
      };
    };
  };
}
