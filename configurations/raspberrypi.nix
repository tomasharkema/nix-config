{ disko, nixpkgs, pkgsFor, inputs, nixos-hardware, ... }:
nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  pkgs = pkgsFor."aarch64-linux";

  specialArgs = { inherit inputs; };

  modules = [
    # /nix/store/dg2g5qwvs36dhfqj9khx4sfv0klwl9f0-source/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix
    # (nixpkgs + "/nixos/modules/installer/sd-card/sd-image-raspberrypi-installer.nix")
    # nixos-hardware.nixosModules.raspberry-pi-4
    # "${nixpkgs}/nixos/modules/profiles/minimal.nix"
    # disko.nixosModules.disko
    # ../common/disks/ext4.nix
    # {
    #   _module.args.disks = [ "/dev/mmcblk0" ];
    # }

    ({ pkgs, ... }: {
      # boot.loader.raspberryPi = {
      #   enable = true;
      #   version = 3;
      #   firmwareConfig = ''
      #     core_freq=250
      #   '';
      # };
      # console.enable = false;
      environment.systemPackages = with pkgs; [
        libraspberrypi
        raspberrypi-eeprom
      ];
      system.stateVersion = "23.11";

      networking.wireless.enable = false;
      # networking.networkmanager.enable = true;

      boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];
      # NixOS wants to enable GRUB by default
      # boot.loader.grub.enable = false;
      # # Enables the generation of /boot/extlinux/extlinux.conf
      # boot.loader.generic-extlinux-compatible.enable = true;
      # boot.loader.grub.enable = false;

      # boot.loader.raspberryPi = {
      #   enable = true;
      #   version = 3;
      #   firmwareConfig = ''
      #     core_freq=250
      #   '';
      # };

      # boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];

      hardware.enableRedistributableFirmware = true;

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@supermicro"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      ];

    })
  ];
}
