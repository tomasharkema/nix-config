{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  imports = [./hardware-configuration.nix];

  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILZP/NhYd8ZBJBXDEDwUgkxQHEBD3DT2KsAQA3bn1MSC root@silver-star-vm";
    };

    swapDevices =
      mkForce [
      ];
    trait = {
      server.enable = true;
      hardware = {
        tpm.enable = true;
        # secure-boot.enable = true;
        vm.enable = true;
      };
    };

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    disks.ext4 = {
      enable = true;
      main = "/dev/disk/by-id/virtio-vdisk1";
    };

    apps.resilio.enable = mkForce false;
    # apps.tor.relay.enable = true;

    apps = {
      # attic-server.enable = true;
      ipa.enable = false;
      mailrise.enable = true;
      buildbot.enable = true;
    };

    services = {
      # netbox-service.enable = true;

      journald.remote.enable = true;

      kmscon = {enable = false;};

      healthchecks = {
        # enable = true;
        listenAddress = "0.0.0.0";

        # notificationSender = "tomas+hydra@harkema.io";
        # useSubstitutes = true;
        # smtpHost = "smtp-relay.gmail.com";

        settings = {
          SECRET_KEY_FILE = "/etc/healthchecks.key";

          EMAIL_HOST = "silver-star-vm.ling-lizard.ts.net";
          EMAIL_PORT = "8025";
          # EMAIL_HOST_USER = "tomas@harkema.io";
          # # EMAIL_HOST_PASSWORD=mypassword
          EMAIL_USE_SSL = "False";
          EMAIL_USE_TLS = "False";
        };
      };

      earlyoom = {enable = mkForce false;};

      tailscale = {
        extraUpFlags =
          mkForce ["--advertise-tags=tag:nixos" "--operator=tomas"];
      };

      freeipa.enable = true;

      resilio.enable = mkForce false;

      ha.initialMaster = true;

      command-center = {enableBot = true;};
    };

    networking = {
      hostName = "silver-star-vm";

      firewall = {
        enable = false;
        allowedTCPPorts = [config.services.buildbot-master.port (toInt config.apps.buildbot.workerPort)];
      };
      # wireless.enable = lib.mkDefault false;
      networkmanager.enable = mkForce false; # true;

      useDHCP = false;
      interfaces."enp3s0".useDHCP = true;
    };

    # sudo mount --types virtiofs appdata_ssd /mnt/shared/
    # fileSystems."/mnt/shared" = {
    #   fsType = "virtiofs";
    #   device = "appdata_ssd";
    # };
  };
}
