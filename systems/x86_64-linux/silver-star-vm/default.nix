{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [./hardware-configuration.nix];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmfcfVeCBPcxmRRDtfSJcnAEZR5puw+h9eLN8M/jKOn root@silver-star-vm";
      };
      secrets = {
        "healthchecks" = {
          rekeyFile = ./healthchecks.age;
        };
      };
    };

    swapDevices = lib.mkForce [];

    traits = {
      server.enable = true;
      builder.enable = true;
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        vm.enable = true;
      };
    };

    boot = {
      loader = {
        # systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    disks.ext4 = {
      enable = true;
      main = "/dev/vda";
    };

    boot.kernelParams = [
      "console=tty1"
      "console=ttyS0,115200"
    ];

    # apps.tor.relay.enable = true;

    # virtualisation = {
    #   oci-containers.containers = {
    #     mackerelGrafana = {
    #       image = "mackerel-to-grafana-oncall:latest";
    #       imageFile = pkgs.custom.mackerel-to-grafana-oncall-docker;

    #       autoStart = true;

    #       # volumes = [
    #       #   "/var/lib/netboot/config:/config"
    #       #   "/var/lib/netboot/assets:/assets"
    #       # ];

    #       cmd = [
    #         "-grafana-oncall-url"
    #       ];

    #       ports = [
    #         "8000:8000"
    #       ];
    #     };
    #   };
    # };

    apps = {
      # attic-server.enable = true;
      ipa.enable = false;
      mailrise.enable = true;
      resilio.enable = lib.mkForce false;
    };

    services = {
      # netbox-service.enable = true;

      # journald.remote.enable = true;

      abrt = {
        enable = true;
        server.enable = true;
      };

      kmscon = {
        enable = false;
      };

      healthchecks = {
        enable = true;
        listenAddress = "0.0.0.0";

        # notificationSender = "tomas+hydra@harkema.io";
        # useSubstitutes = true;
        # smtpHost = "smtp-relay.gmail.com";

        settings = {
          SECRET_KEY_FILE = config.age.secrets.healthchecks.path;

          EMAIL_HOST = "silver-star-vm.ling-lizard.ts.net";
          EMAIL_PORT = "8025";
          # EMAIL_HOST_USER = "tomas@harkema.io";
          # # EMAIL_HOST_PASSWORD=mypassword
          EMAIL_USE_SSL = "False";
          EMAIL_USE_TLS = "False";
        };
      };

      earlyoom = {
        enable = lib.mkForce false;
      };

      tailscale = {
        extraUpFlags = lib.mkForce ["--operator=tomas"];
      };

      # freeipa.enable = true;

      resilio.enable = lib.mkForce false;
    };

    networking = {
      hostName = "silver-star-vm";

      firewall = {
        enable = false;
      };
      # wireless.enable = lib.mkDefault false;
      networkmanager.enable = lib.mkForce false; # true;

      useDHCP = false;
      interfaces."enp3s0".useDHCP = true;
    };
  };
}
