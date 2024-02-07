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
      resilio = {
        enable = lib.mkForce false;
      };
    };
    # boot.kernelPackages = pkgs.linuxPackages_latest;

    networking = {
      hostName = "silver-star-vm";
      firewall.enable = lib.mkForce false;
      nftables.enable = lib.mkForce false;
      wireless.enable = lib.mkDefault false;
      networkmanager.enable = true;
      useDHCP = lib.mkForce true;
    };

    # sudo mount --types virtiofs appdata_ssd /mnt/shared/
    # fileSystems."/mnt/shared" = {
    #   fsType = "virtiofs";
    #   device = "appdata_ssd";
    # };
  };
}
