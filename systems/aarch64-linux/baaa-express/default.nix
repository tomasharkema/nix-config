{
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs; [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
  ];
  config = {
    networking.hostName = "baaa-express";

    traits.raspberry.enable = true;

    sdImage.compressImage = false;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];
    # system.stateVersion = "23.11";

    # boot.kernelParams = [
    #   "console=ttyS1,115200n8"
    #   "cma=320M"
    # ];

    # fileSystems."/".fsType = lib.mkForce "tmpfs";
    # fileSystems."/".device = lib.mkForce "none";

    boot.initrd.kernelModules = ["vc4" "bcm2835_dma" "i2c_bcm2835"];

    # boot.loader.raspberryPi = {
    #   enable = true;
    #   version = 3;
    #   firmwareConfig = ''
    #     core_freq=250
    #   '';
    # };

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
