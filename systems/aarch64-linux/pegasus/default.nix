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

    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIMzZxdX/aTyjIrUUFwSKo3zVo2iGJ/PS9uu9KDZXb4b root@pegasus";
    };

    facter.reportPath = ./facter.json;

    services = {
      # udev.extraRules = ''
      #   # allow access to raspi cec device for video group (and optionally register it as a systemd device, used below)
      #   KERNEL=="vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
      # '';

      # remote-builders.client.enable = true;
    };
    # optional: attach a persisted cec-client to `/run/cec.fifo`, to avoid the CEC ~1s startup delay per command
    # scan for devices: `echo 'scan' > /run/cec.fifo ; journalctl -u cec-client.service`
    # set pi as active source: `echo 'as' > /run/cec.fifo`
    # systemd = {
    #   sockets."cec-client" = {
    #     after = ["dev-vchiq.device"];
    #     bindsTo = ["dev-vchiq.device"];
    #     wantedBy = ["sockets.target"];
    #     socketConfig = {
    #       ListenFIFO = "/run/cec.fifo";
    #       SocketGroup = "video";
    #       SocketMode = "0660";
    #     };
    #   };

    #   services."cec-client" = {
    #     after = ["dev-vchiq.device"];
    #     bindsTo = ["dev-vchiq.device"];
    #     wantedBy = ["multi-user.target"];
    #     serviceConfig = {
    #       ExecStart = "${pkgs.libcec}/bin/cec-client -d 1";
    #       ExecStop = ''/bin/sh -c "echo q > /run/cec.fifo"'';
    #       StandardInput = "socket";
    #       StandardOutput = "journal";
    #       Restart = "no";
    #     };
    #   };
    # };

    networking = {
      hostName = "pegasus";
      firewall.enable = true;
      networkmanager.enable = true;
    };

    # zramSwap = {enable = true;};
    # swapDevices = [
    #   {
    #     device = "/swapfile";
    #     size = 16 * 1024;
    #   }
    # ];

    traits = {
      hardware.raspberry.enable = true;
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
      ncspot
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

    # proxy-services = {enable = false;};
    # raspberry-pi-nix.board = "bcm2711";

    fileSystems = {
      # "/boot" = {
      #   device = "/dev/disk/by-label/NIXOS_BOOT";
      #   fsType = "vfat";
      # };
      # "/" = {
      #   device = "/dev/disk/by-label/NIXOS_SD";
      #   fsType = "ext4";
      # };
    };

    services.hardware.lcd = {
      server = {
        enable = true;
        # extraConfig = ''
        #   Driver=glcdlib

        #   [glcdlib]
        #   Driver=framebuffer
        #   UseFT2=yes
        #   FontFile=${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf
        # '';
        extraConfig = ''
          Driver=curses

          ## Curses driver ##
          [curses]

          # color settings
          # foreground color [default: blue]
          Foreground=white
          # background color when "backlight" is off [default: cyan]
          Background=black
          # background color when "backlight" is on [default: red]
          Backlight=black

          # display size [default: 20x4]
          Size=16x3

          # What position (X,Y) to start the left top corner at...
          # Default: (7,7)
          TopLeftX=0
          TopLeftY=0

          # use ASC symbols for icons & bars [default: no; legal: yes, no]
          UseACS=no

          # draw Border [default: yes; legal: yes, no]
          DrawBorder=no

        '';
      };

      client = {
        enable = true;

        extraConfig = ''

          [CPU]
          # Show screen
          Active=True
          OnTime=1
          OffTime=2
          ShowInvisible=false


          [Iface]
          # Show screen
          Active=True

          # Show stats for Interface0
          Interface0=eth0
          # Interface alias name to display [default: <interface name>]
          Alias0=LAN

          # Show stats for Interface1
          #Interface1=eth1
          #Alias1=WAN

          # Show stats for Interface2
          #Interface2=eth2
          #Alias2=MGMT

          # for more than 3 interfaces change MAX_INTERFACES in iface.h and rebuild

          # Units to display [default: byte; legal: byte, bit, packet]
          unit=bit

          # add screen with transferred traffic
          #transfer=TRUE


          [Memory]
          # Show screen
          Active=True


          [Load]
          # Show screen
          Active=True
          # Min Load Avg at which the backlight will be turned off [default: 0.05]
          LowLoad=0.05
          # Max Load Avg at which the backlight will start blinking [default: 1.3]
          HighLoad=1.3


          [SMP-CPU]
          # Show screen
          Active=true

          [Battery]
          # Show screen
          Active=false


          [CPUGraph]
          # Show screen
          Active=true


          [ProcSize]
          # Show screen
          Active=true


          [Disk]
          # Show screen
          Active=true
          # You can add up to 10 "Ignore" entries to have lcdproc ignore
          # mounts that are not of interest. By default it attempts to filter
          # filesystem types like procfs but of course this doesn't prevent
          # entries you wish to have mounted but don't need to monitor
          # (like /boot/efi) from being listed.
          Ignore=/boot/efi
          Ignore=/dev
          #Ignore=...

        '';
      };
    };

    systemd.services = {
      lcdd.serviceConfig = {
        StandardOutput = "tty";
        TTYPath = "/dev/tty1";
      };
      "getty@tty1".enable = false;
    };

    environment.etc."graphlcd.conf".text = ''
      WaitMethod=3
      WaitPriority=0

      [framebuffer]
      # framebuffer driver
      #  Output goes to a framebuffer device
      Driver=framebuffer

      #UpsideDown=no
      #Invert=no

      # Device
      #  Framebuffer device
      #  Default value: /dev/fb0
      Device=/dev/fb0

      # Damage | ReportDamage
      #  Damage reporting for framebuffer devices with update problems
      #  Possible values: none, auto, udlfb, ugly
      #    none:  no damage reporting
      #    auto:  automatic determination if damage reporting is needed
      #    udlfb: damage reporting for udlfb-devices (displaylink)
      #    ugly:  dirty damagereporting (a '\n' is written to the framebuffer file handle)
      #  Default value: none
      #Damage=none

      # Zoom
      #  Determines if pixels should be drawn double sized.
      #  If zoom is set, the actual resolution will be halved (both width and height)
      #  e.g.: framebuffer has resolution 800x600: this driver will report a drawing area of 400x300
      #  Possible values: 0, 1
      #  Default value: 1
      Zoom=0

      Width=128
      Height=32
    '';

    hardware = {
      # raspberry-pi.config = {
      #   # uboot = false;
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
      deviceTree = {
        enable = true;
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
