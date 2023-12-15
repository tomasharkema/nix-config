{ disko, nixpkgs, pkgsFor, inputs, nixos-hardware, ... }:
nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  pkgs = pkgsFor."aarch64-linux";

  specialArgs = { inherit inputs; };

  modules = [
    # /nix/store/dg2g5qwvs36dhfqj9khx4sfv0klwl9f0-source/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix
    # (nixpkgs + "/nixos/modules/installer/sd-card/sd-image-raspberrypi-installer.nix")
    nixos-hardware.nixosModules.raspberry-pi-4
    "${nixpkgs}/nixos/modules/profiles/minimal.nix"
    # disko.nixosModules.disko
    # ../common/disks/ext4.nix
    # {
    #   _module.args.disks = [ "/dev/mmcblk0" ];
    # }

    ({ pkgs, ... }: {
      hardware = {
        raspberry-pi."4".apply-overlays-dtmerge.enable = true;
        deviceTree = {
          enable = true;
          filter = "*rpi-4-*.dtb";
        };
      };
      console.enable = false;
      environment.systemPackages = with pkgs; [
        libraspberrypi
        raspberrypi-eeprom
      ];
      system.stateVersion = "23.11";


      imports = [

        #   (nixpkgs + "/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix")
      ];
      # NixOS wants to enable GRUB by default
      # boot.loader.grub.enable = false;
      # # Enables the generation of /boot/extlinux/extlinux.conf
      # boot.loader.generic-extlinux-compatible.enable = true;

      # boot.loader.raspberryPi = {
      #   enable = true;
      #   version = 3;
      #   firmwareConfig = ''
      #     core_freq=250
      #   '';
      # };

      # boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];

      # hardware.enableRedistributableFirmware = true;
      networking.wireless.enable = true;

    })
  ];
}
