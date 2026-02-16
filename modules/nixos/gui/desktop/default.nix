{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.gui.desktop;
  foxBg = pkgs.fetchurl {
    url = "https://firefox-settings-attachments.cdn.mozilla.net/main-workspace/newtab-wallpapers-v2/d8b71c77-9985-41d2-b98e-51bebc60e595.avif";

    sha256 = "06121rwydvmr9dc757ixxr59rfcask8p74mmsmprpcndddp55fgf";
  };
in {
  options.gui.desktop = {
    enable = lib.mkEnableOption "desktop";

    # rdp = {
    #   enable = lib.mkEnableOption "desktop rdp";
    # };
  };

  config = lib.mkIf (cfg.enable) {
    assertions = [
      {
        assertion = config.gui.enable;
        message = "you can't enable this for that reason";
      }
    ];

    # qt = {
    #   enable = true;
    #   platformTheme = "gnome";
    #   style = "adwaita-dark";
    # };

    nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

    system.build.gui.foxBg = foxBg;
    users.users.tomas.extraGroups = ["adbusers" "kvm"];
    # home-manager.users.tomas = {
    #   services.tailscale-systray.enable = true;
    #   systemd.user.targets.tray = {
    #     Unit = {
    #       Description = "Home Manager System Tray";
    #       Requires = ["graphical-session-pre.target"];
    #     };
    #   };
    # };

    gui.fonts.enable = true;

    # i18n.inputMethod = {
    #   enable = true;
    #   type = "ibus";
    #   ibus.engines = with pkgs.ibus-engines; [
    #     uniemoji
    #     typing-booster
    #   ];
    # };

    # security.pam.services.passwd.enableGnomeKeyring = true;

    apps.gpsd.enable = true;

    services = {
      # localtimed.enable = true;
      # uvcvideo.dynctrl = {
      #   enable = true;
      #   packages = [pkgs.tiscamera];
      # };
      gnome = {
        # gnome-keyring.enable = false; # true;
        gnome-online-accounts.enable = true;
      };
      pulseaudio.enable = false;

      ratbagd.enable = true;
      usbmuxd.enable = true;

      ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
        extraRules = [
          {
            name = "nom";
            type = "compiler";
          }
          {
            name = "nix";
            type = "compiler";
          }
          {
            name = "nix-daemon";
            type = "compiler";
          }
          {
            name = "nh";
            type = "compiler";
          }
        ];
      };

      udev = {
        packages = with pkgs; [
          saleae-logic-2
          nrf-udev
        ];

        customRules = [
          {
            name = "50-qmk";
            rules = ''
              KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", \
                MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
              # Atmel DFU
              ### ATmega16U2
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2fef", TAG+="uaccess"
              ### ATmega32U2
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff0", TAG+="uaccess"
              ### ATmega16U4
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff3", TAG+="uaccess"
              ### ATmega32U4
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess"
              ### AT90USB64
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff9", TAG+="uaccess"
              ### AT90USB162
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ffa", TAG+="uaccess"
              ### AT90USB128
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ffb", TAG+="uaccess"

              # Input Club
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="1c11", ATTRS{idProduct}=="b007", TAG+="uaccess"

              # STM32duino
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="1eaf", ATTRS{idProduct}=="0003", TAG+="uaccess"
              # STM32 DFU
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", TAG+="uaccess"

              # BootloadHID
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05df", TAG+="uaccess"

              # USBAspLoader
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", TAG+="uaccess"

              # USBtinyISP
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="1782", ATTRS{idProduct}=="0c9f", TAG+="uaccess"

              # ModemManager should ignore the following devices
              # Atmel SAM-BA (Massdrop)
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"

              # Caterina (Pro Micro)
              ## pid.codes shared PID
              ### Keyboardio Atreus 2 Bootloader
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2302", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
              ## Spark Fun Electronics
              ### Pro Micro 3V3/8MHz
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9203", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
              ### Pro Micro 5V/16MHz
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9205", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
              ### LilyPad 3V3/8MHz (and some Pro Micro clones)
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9207", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
              ## Pololu Electronics
              ### A-Star 32U4
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="1ffb", ATTRS{idProduct}=="0101", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
              ## Arduino SA
              ### Leonardo
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0036", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
              ### Micro
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0037", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
              ## Adafruit Industries LLC
              ### Feather 32U4
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000c", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
              ### ItsyBitsy 32U4 3V3/8MHz
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000d", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
              ### ItsyBitsy 32U4 5V/16MHz
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="239a", ATTRS{idProduct}=="000e", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
              ## dog hunter AG
              ### Leonardo
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="2a03", ATTRS{idProduct}=="0036", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"
              ### Micro
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="2a03", ATTRS{idProduct}=="0037", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1"

              # hid_listen
              KERNEL=="hidraw*", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"

              # hid bootloaders
              ## QMK HID
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2067", TAG+="uaccess"
              ## PJRC's HalfKay
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="0478", TAG+="uaccess"

              # APM32 DFU
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="314b", ATTRS{idProduct}=="0106", TAG+="uaccess"

              # GD32V DFU
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="28e9", ATTRS{idProduct}=="0189", TAG+="uaccess"

              # WB32 DFU
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="342d", ATTRS{idProduct}=="dfa0", TAG+="uaccess"

              # AT32 DFU
              SUBSYSTEMS=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", TAG+="uaccess"

            '';
          }
        ];
      };
      scx = {
        enable = pkgs.stdenvNoCC.isx86_64;
        # package = pkgs.scx_git.rustscheds;
        # scheduler = "scx_lavd"; #
        scheduler = "scx_bpfland";
      };

      hardware = {
        openrgb = {
          enable = true;
          package = pkgs.openrgb-with-all-plugins;
          startupProfile = "default";
        };
      };

      dbus = {
        enable = true;
        packages = with pkgs; [
          # custom.anydesk
          # tilix
          kdiskmark
        ];
      };
      # xrdp = mkIf cfg.rdp.enable {
      #   enable = true;
      #   # openFirewall = true;
      # };
      # clipmenu.enable = true;

      xserver.videoDrivers = ["displaylink"];

      systembus-notify.enable = true;
      gvfs = {
        enable = true;
        package = pkgs.gvfs.override {
          gnomeSupport = true;
          googleSupport = true;
        };
      };
    };

    security.polkit = {
      enable = true;
    };

    environment = {
      etc = {
        "xdg/autostart/geary-autostart.desktop".source = "${pkgs.geary}/share/applications/geary-autostart.desktop";
      };

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        # DMS_DISABLE_MATUGEN = "1";
        QMK_HOME = "/home/tomas/Developer/qmk_firmware";
      };

      pathsToLink = ["share/thumbnailers"];

      systemPackages = with pkgs; [
        kdiskmark

        libheif
        libheif.out

        config.boot.kernelPackages.iio-utils
      ];
    };

    hardware = {
      saleae-logic.enable = true;
      libftdi.enable = true;
      libjaylink.enable = true;

      usb-modeswitch.enable = true;
      opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
      keyboard.qmk.enable = true;
      intel-gpu-tools.enable = false;
      acpilight.enable = true;
      sensor = {
        hddtemp.enable = true;
        iio.enable = true;
      };
    };

    programs = {
      pulseview.enable = true;
      sniffnet.enable = true;
      television = {
        enable = true;
        enableZshIntegration = true;
      };
      zmap.enable = true;
      geary.enable = true;
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };

      ghidra = {
        enable = true;
        package = pkgs.ghidra.withExtensions (p:
          with p; [
            ret-sync
            # gnudisassembler
            findcrypt
            ghidra-delinker-extension
            ghidra-firmware-utils
            ghidra-golanganalyzerextension
          ]);
      };

      oddjobd.enable = true;
      ssh = {
        # startAgent = true;
      };
      mtr.enable = true;
      dconf.enable = true;

      chromium = {
        enable = true;
      };

      appimage = {
        enable = true;
        binfmt = true;
      };
      virt-manager.enable = true;
    };

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        akvcam
        v4l2loopback
        iio-utils
      ];
      kernelModules = ["v4l2loopback" "akvcam"];

      # for displaylink
      # kernelPackages = pkgs.linuxPackages_6_17;
    };

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];

    # networking.firewall = {
    #   allowedTCPPorts = [
    #     1900
    #     5353
    #     8324
    #     8080
    #     8060 # the plex frontend does upnp things
    #     32433 # plex-media-player
    #     32410
    #     32412
    #     32413
    #     32414
    #     32469
    #   ];
    # };

    apps.firefox.enable = true;

    systemd = {
      services = {
        # "prepare-kexec".wantedBy = lib.mkIf pkgs.stdenv.isx86_64 ["multi-user.target"];
        NetworkManager-wait-online.enable = lib.mkForce false;
        systemd-networkd-wait-online.enable = lib.mkForce false;
      };
      packages =
        [
          pkgs.custom.wifiman
        ]
        ++ (lib.optional pkgs.stdenv.isx86_64 pkgs.widevine-cdm);
      additionalUpstreamSystemUnits = ["systemd-bsod.service"];
    };

    # Enable sound with pipewire.
    # sound.enable = mkDefault true;
    security.rtkit.enable = true;
  };
}
