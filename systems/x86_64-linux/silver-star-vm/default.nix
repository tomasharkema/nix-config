{
  lib,
  pkgs,
  config,
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

    resilio.enable = mkForce false;
    # apps.tor.relay.enable = true;

    systemd.services.netbox = {
      serviceConfig = {
        TimeoutSec = 900;
      };
    };

    proxy-services.services = {
      "/netbox/static/" = {alias = "${config.services.netbox.dataDir}/static/";};
      "/netbox/" = {
        proxyPass = "http://${config.services.netbox.listenAddress}:${toString config.services.netbox.port}";
        # extraConfig = ''
        #   rewrite /netbox(.*) $1 break;
        # '';
      };
    };

    services = {
      podman.enable = true;

      netbox = {
        enable = true;
        secretKeyFile = "/var/lib/netbox/secret-key-file";
        listenAddress = "127.0.0.1";
        settings = {
          BASE_PATH = "netbox/";
        };
      };

      qemuGuest.enable = true;
      freeipa.enable = true;
      resilio = {
        enable = lib.mkForce false;
      };
      ha.initialMaster = true;
      command-center = {
        enableBot = true;
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
