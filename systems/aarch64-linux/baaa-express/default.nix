{
  pkgs,
  inputs,
  lib,
  ...
}: {
  # imports = with inputs; [
  # nixos-hardware.nixosModules.raspberry-pi-4
  # ];

  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGUTP5KhcV1yxEU58RGanzhh5x/mWVH5aGJVSPGz1r6B root@baaa-express";
    };

    networking = {
      firewall.enable = false;
      hostName = "baaa-express";
      networkmanager.enable = true;
    };

    fileSystems = {
      # "/boot" = {
      #   device = "/dev/disk/by-label/NIXOS_BOOT";
      #   fsType = "vfat";
      # };
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };
    };
    # traits.raspberry.enable = true;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];

    traits = {
      low-power.enable = true;
      hardware = {
        bluetooth.enable = true;
      };
    };
    # traits.slim.enable = true;

    gui."media-center".enable = true;

    apps = {
      spotifyd.enable = true;
      cec.enable = true;
      unified-remote.enable = true;
    };

    services = {
      remote-builders.client.enable = true;
      avahi = {
        enable = true;
      };
      mopidy = {
        enable = true;
        extensionPackages = with pkgs; [
          mopidy-spotify
          mopidy-mpd
          mopidy-mpris
          mopidy-notify
          mopidy-mopify
          mopidy-podcast
          mopidy-musicbox-webclient
        ];
      };
    };

    # system.stateVersion = "25.05";

    # fileSystems."/".fsType = lib.mkForce "tmpfs";
    # fileSystems."/".device = lib.mkForce "none";
    zramSwap = {
      enable = false;
    };
    swapDevices = [
      {
        device = "/swapfile";
        size = 16 * 1024;
      }
    ];

    services = {
      cage.program = lib.mkForce "${pkgs.kodi-wayland}/bin/kodi-standalone";
    };

    programs.atop = {
      enable = lib.mkForce false;
      netatop.enable = false;
    };

    nix.settings = {
      keep-outputs = lib.mkForce false;
      keep-derivations = lib.mkForce false;
    };

    boot = {
      loader = {
        grub.enable = lib.mkDefault false;
        generic-extlinux-compatible.enable = lib.mkDefault true;
      };

      initrd.kernelModules = [
        "vc4"
        "bcm2835_dma"
        "i2c_bcm2835"
        # "dwc2"
        # "g_serial"
      ];
      # initrd.availableKernelModules = lib.mkForce [
      #   "ext2"
      #   "ext4"
      #   "sd_mod"
      #   "sr_mod"
      #   "ehci_hcd"
      #   "ohci_hcd"
      #   "xhci_hcd"
      #   "usbhid"
      #   "hid_generic"
      #   "hid_lenovo"
      #   "hid_apple"
      #   "hid_roccat"
      #   "hid_logitech_hidpp"
      #   "hid_logitech_dj"
      #   "hid_microsoft"
      #   "hid_cherry"
      #   "hid_corsair"
      # ];

      # kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;

      kernelParams = lib.mkForce [
        # "console=ttyS0,115200n8"
        "console=ttyS1,115200n8"
        # "console=tty0"
        "cma=320M"
      ];
    };

    hardware.pulseaudio.enable = false;

    services.pipewire = {
      wireplumber = {
        enable = true;
        extraConfig = {
          # "monitor.bluez.properties" = {
          #   "bluez5.roles" = [
          #     "a2dp_sink"
          #     "a2dp_source"
          #     "bap_sink"
          #     "bap_source"
          #     "hsp_hs"
          #     "hsp_ag"
          #     "hfp_hf"
          #     "hfp_ag"
          #   ];
          #   "bluez5.codecs" = [
          #     "sbc"
          #     "sbc_xq"
          #     "aac"
          #   ];
          #   "bluez5.enable-sbc-xq" = true;
          #   "bluez5.hfphsp-backend" = "native";
          #   "bluez5.auto-connect" = [
          #     "hfp_hf"
          #     "hsp_hs"
          #     "a2dp_sink"
          #   ];
          # };
        };
      };
      systemWide = true;

      # extraConfig.pipewire-pulse."91-bluetooth" = {
      #   context.modules = [
      #     {
      #       name = "module-bluetooth-discover";
      #       args = { };
      #     }
      #     {
      #       name = "module-bluetooth-policy";
      #       args = { };
      #     }
      #   ];
      # };
    };

    hardware = {
      enableRedistributableFirmware = true;
      i2c.enable = true;

      bluetooth.settings = {
        General = {
          Class = "0x200414";
          DiscoverableTimeout = 0;
        };
        Policy = {
          AutoEnable = true;
        };
      };

      # deviceTree = let drMode = "otg";
      # in {
      #   filter = lib.mkDefault "*rpi-3-b.dtb";
      #   enable = true;

      #   overlays = [{
      #     name = "dwc2";
      #     dtboFile =
      #       "${pkgs.raspberrypifw}/share/raspberrypi/boot/overlays/dwc2.dtbo";
      #   }];
      # };
    };

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
