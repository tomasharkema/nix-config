{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = with inputs; [
    # nixos-hardware.nixosModules.raspberry-pi-4
    # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
    # "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
    nixpkgs.buildPlatform = builtins.currentSystem;

    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBanxLefIcrVxhtzYj7OvNwZj3P5upoj7AwVyV0Id5T7 root@pegasus";
    };

    services = {
      # udev.extraRules = ''
      #   # allow access to raspi cec device for video group (and optionally register it as a systemd device, used below)
      #   KERNEL=="vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
      # '';

      # remote-builders.client.enable = true;
    };

    networking = {
      hostName = "kvmpiz2";
      firewall.enable = true;
      networkmanager.enable = true;
    };

    virtualisation.vmVariant = {
      virtualisation = {
        diskSize = 50 * 1024;
        memorySize = 4 * 1024;
        cores = 4;
      };
    };

    zramSwap = {enable = true;};
    swapDevices = [
      {
        device = "/swapfile";
        size = 16 * 1024;
      }
    ];

    traits = {
      # raspberry.enable = true;
      low-power.enable = true;
      hardware.bluetooth.enable = true;
    };

    # gui."media-center".enable = true;

    apps = {
      # spotifyd.enable = true;
      # cec = {
      #   enable = true;
      #   raspberry = true;
      # };
      # unified-remote.enable = true;
      # netdata.enable = true;
    };

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
      # ncspot
      # libcec
      # pkgs.custom.playercast
    ];

    nix.settings = {
      keep-outputs = lib.mkForce false;
      keep-derivations = lib.mkForce false;
    };

    # boot = {
    #   kernelPackages = pkgs.linuxPackages_rpi4;
    # };

    hardware = {
      # raspberry-pi.config = {
      #   pi4 = {
      #     options = {
      #       arm_boost = {
      #         enable = true;
      #         value = true;
      #       };
      #     };
      #     dt-overlays = {
      #       vc4-kms-v3d = {
      #         enable = true;
      #         params = {cma-512 = {enable = true;};};
      #       };
      #     };
      #   };
      #   all = {
      #     options = {
      #       # The firmware will start our u-boot binary rather than a
      #       # linux kernel.
      #       # kernel = {
      #       #   enable = true;
      #       #   value = "u-boot-rpi-arm64.bin";
      #       # };
      #       arm_64bit = {
      #         enable = true;
      #         value = true;
      #       };
      #       enable_uart = {
      #         enable = true;
      #         value = true;
      #       };
      #     };

      #     dt-overlays = {
      #       vc4-kms-v3d = {
      #         enable = true;
      #         params = {};
      #       };
      #     };
      #   };
      # };

      enableRedistributableFirmware = true;
      i2c.enable = true;

      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          # libvdpau-va-gl
        ];
      };

      # raspberry-pi."4" = {
      #   apply-overlays-dtmerge.enable = true;
      #   fkms-3d = {
      #     enable = true;
      #     # cma = 1024;
      #   };
      #   # dwc2 = {
      #   #   enable = true;
      #   #   dr_mode = "peripheral";
      #   # };
      #   # xhci.enable = true;
      #   # i2c0.enable = true;
      #   # audio.enable = true;
      # };

      # deviceTree = {
      # enable = true;
      # filter = "bcm2711-rpi-4*.dtb";
      # filter = mkForce "*rpi-4-*.dtb";
      # };
    };
  };
}
