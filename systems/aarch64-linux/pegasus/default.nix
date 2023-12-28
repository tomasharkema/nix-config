{
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs; [
    nixos-hardware.nixosModules.raspberry-pi-4
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
    "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  config = {
    networking.hostName = "pegasus";

    traits.raspberry.enable = true;

    environment.systemPackages = with pkgs; [
      raspberrypi-eeprom
    ];

    hardware = {
      raspberry-pi."4" = {
        apply-overlays-dtmerge.enable = true;
        dwc2.enable = true;
        fkms-3d.enable = true;
      };
      deviceTree = {
        enable = true;
        filter = "*rpi-4-*.dtb";
      };
    };
  };
}
