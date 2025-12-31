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

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    system.build.gui.foxBg = foxBg;

    home-manager.users.tomas = {
      # services.tailscale-systray.enable = true;
      # systemd.user.services.tailscale-systray.Service = {
      #   TimeoutStopSec = "5s";
      #   Slice = "app.slice";
      # };
    };

    gui.fonts.enable = true;

    i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [
        uniemoji
        typing-booster
      ];
    };

    # security.pam.services.passwd.enableGnomeKeyring = true;

    apps.gpsd.enable = true;

    services = {
      # localtimed.enable = true;

      udev = {
        packages = with pkgs; [
          saleae-logic-2
          nrf-udev
        ];
        extraRules = ''
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", \
            MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

          ${builtins.readFile ./50-qmk.rules}
        '';
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

      xserver.videoDrivers =
        #lib.mkIf (lib.strings.versionOlder config.boot.kernelPackages.kernel.version "6.18")
        ["displaylink"];

      systembus-notify.enable = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;

        wireplumber = {
          enable = true;
          extraConfig = {
            "monitor.bluez.properties" = {
              "bluez5.dummy-avrcp-player" = true;
            };
            bluetoothEnhancements = {
              "monitor.bluez.properties" = {
                "bluez5.dummy-avrcp-player" = true;
                "bluez5.enable-sbc-xq" = true;
                "bluez5.enable-msbc" = true;
                "bluez5.enable-hw-volume" = true;
                "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
              };
            };
          };
        };
        lowLatency = {
          # enable this module
          # enable = true;
        };
      };
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
      extraConfig =
        lib.mkIf false
        # cfg.rdp.enable
        ''
          polkit.addRule(function(action, subject) {
            if (
              subject.isInGroup("users")
                && (
                  action.id == "org.freedesktop.login1.reboot" ||
                  action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                  action.id == "org.freedesktop.login1.power-off" ||
                  action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                )
              )
            {
              return polkit.Result.YES;
            }
          })
        '';
    };

    environment = {
      etc = {
        "xdg/autostart/geary-autostart.desktop".source = "${pkgs.geary}/share/applications/geary-autostart.desktop";
      };

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        DMS_DISABLE_MATUGEN = "1";
        QMK_HOME = "/home/tomas/Developer/qmk_firmware";
      };

      systemPackages = with pkgs; [
        kdiskmark
        config.boot.kernelPackages.iio-utils
        qmk
        qmk_hid
        dos2unix
        via
        vial
      ];
    };

    hardware = {
      saleae-logic.enable = true;
      libftdi.enable = true;
      libjaylink.enable = true;
      pulseaudio.enable = false;
      usb-modeswitch.enable = true;
      opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
      keyboard.qmk.enable = true;
      intel-gpu-tools.enable = true;
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
      # plotinus.enable = true;

      ghidra = {
        enable = true;
        package = pkgs.ghidra.withExtensions (p:
          with p; [
            ret-sync
            gnudisassembler
            findcrypt
            ghidra-delinker-extension
            ghidra-firmware-utils
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

      #chromium = {
      #  enable = true;
      #};
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

    services.gnome = {
      # gnome-keyring.enable = false; # true;
      gnome-online-accounts.enable = true;
    };

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
      packages =
        [
          #config.system.build.chromium
          pkgs.custom.wifiman
        ]
        ++ (lib.optional pkgs.stdenv.isx86_64 pkgs.widevine-cdm);
      additionalUpstreamSystemUnits = ["systemd-bsod.service"];
    };

    # Enable sound with pipewire.
    # sound.enable = mkDefault true;
    security.rtkit.enable = true;

    #system.build.chromium = pkgs.chromium.override {
    #  enableWideVine = pkgs.stdenv.isx86_64;
    #  commandLineArgs = [
    #    "--enable-features=VaapiVideoDecodeLinuxGL"
    #    "--ignore-gpu-blocklist"
    #    "--enable-zero-copy"
    #  ];
    #};
  };
}
