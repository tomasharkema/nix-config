{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    networking.hostName = "silver-star-vm";

    services.resilio = {
      enable = lib.mkForce false;
    };
    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        vm.enable = true;
      };
    };
    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/virtio-vdisk1";
    };
    boot.bootspec.enable = true;

    networking.firewall.enable = false;
    networking.nftables.enable = lib.mkForce false;
    networking.wireless.enable = lib.mkDefault false;
  };
}
