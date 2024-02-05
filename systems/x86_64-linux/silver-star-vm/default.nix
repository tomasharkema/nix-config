{
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    networking.hostName = "silver-star-vm";

    services.resilio = {
      enable = lib.mkForce false;
    };
    headless.enable = true;
    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        vm.enable = true;
      };
    };
    disks.ext4 = {
      enable = true;
      main = "/dev/disk/by-id/virtio-vdisk1";
    };

    apps.tor.relay.enable = true;
    services = {
      qemuGuest.enable = true;
      freeipa.enable = true;
      nginx.enable = mkForce false;
    };
    # boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.firewall.enable = lib.mkForce false;
    networking.nftables.enable = lib.mkForce false;
    networking.wireless.enable = lib.mkDefault false;
    networking.networkmanager.enable = true;
    networking.useDHCP = lib.mkForce true;

    # sudo mount --types virtiofs appdata_ssd /mnt/shared/
    # fileSystems."/mnt/shared" = {
    #   fsType = "virtiofs";
    #   device = "appdata_ssd";
    # };
  };
}
