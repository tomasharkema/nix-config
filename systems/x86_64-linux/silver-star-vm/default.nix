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
    installed = true;
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

    apps = {
      attic-server.enable = true;
      ipa.enable = false;
    };

    services = {
      # netbox-service.enable = true;

      healthchecks = {
        enable = true;

        settings = {
          SECRET_KEY_FILE = "/etc/healthchecks.key";
        };
      };

      earlyoom = {
        enable = mkForce false;
      };

      tailscale = {
        extraUpFlags = mkForce [
          "--advertise-tags=tag:nixos"
          "--operator=tomas"
        ];
      };

      freeipa.enable = true;

      resilio.enable = mkForce false;

      ha.initialMaster = true;

      command-center = {
        enableBot = true;
      };
    };

    networking = {
      hostName = "silver-star-vm";

      firewall.enable = true;
      # wireless.enable = lib.mkDefault false;
      networkmanager.enable = mkForce false; #true;

      useDHCP = false;
      interfaces."enp3s0".useDHCP = true;

      hosts = {
        "192.168.0.11" = ["blue-fire.harkema.intra" "blue-fire.ling-lizard.ts.net"];
      };
    };

    # sudo mount --types virtiofs appdata_ssd /mnt/shared/
    # fileSystems."/mnt/shared" = {
    #   fsType = "virtiofs";
    #   device = "appdata_ssd";
    # };
  };
}
