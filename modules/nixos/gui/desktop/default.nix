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

  androidEnv = pkgs.androidenv.override {licenseAccepted = true;};
  androidComposition = androidEnv.composeAndroidPackages {
    #cmdLineToolsVersion = "8.0";
    #platformToolsVersion = "36.0.2";
    #buildToolsVersions = ["36.1.0"];
    #platformVersions = ["36.0.2"];
    abiVersions = ["x86_64"];
    includeNDK = false;
    includeSystemImages = true;
    #systemImageTypes = ["google_apis" "google_apis_playstore"];
    includeEmulator = true;
    useGoogleAPIs = true;
    extraLicenses = [
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "android-sdk-license"
      "android-sdk-preview-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };
  androidSdk = androidComposition.androidsdk;
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

    system.build.gui.foxBg = foxBg;
    users.users.tomas.extraGroups = [
      "adbusers"
      "kvm"
      "usbmux"
    ];
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
          qmk-udev-rules
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
        QT_QPA_PLATFORM = "wayland;xcb";
        # DMS_DISABLE_MATUGEN = "1";
        QMK_HOME = "/home/tomas/Developer/qmk_firmware";
        PICO_SDK_PATH = "${pkgs.pico-sdk}/lib/pico-sdk";
        ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
        ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
        JAVA_HOME = pkgs.jdk11.home;
        GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/34.0.2/aapt2";
      };

      pathsToLink = ["share/thumbnailers"];

      systemPackages = with pkgs; [
        kdiskmark
        jdk11
        gradle
        androidSdk
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
      # pulseview.enable = true;
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

      firefox = {
        enable = true;

        nativeMessagingHosts.packages = [
          # pkgs.custom.firefox-webserial
          # pkgs.firefoxpwa
        ];
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
      kernelModules = [
        "v4l2loopback"
        "akvcam"
        "binder_linux"
        "ntsync"
      ];

      modprobeConfig.enable = true;
      extraModprobeConfig = ''
        options binder_linux devices=binder,hwbinder,vndbinder
      '';

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

      user.services.fumon = {
        description = "User unit failure monitor";
        documentation = ["man:fumon(1)" "man:busctl(1)"];
        requisite = ["graphical-session.target"];
        after = ["graphical-session.target"];
        enable = true;
        serviceConfig = {
          Type = "exec";
          # ExecCondition=/bin/sh -c "command -v notify-send > /dev/null"
          ExecStart = "${pkgs.uwsm}/bin/fumon";
          Restart = "on-failure";
          Slice = "background-graphical.slice";
        };

        wantedBy = ["graphical-session.target"];
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
