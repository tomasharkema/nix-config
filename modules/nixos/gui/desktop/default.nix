{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.gui.desktop;
in {
  options.gui.desktop = {
    enable = lib.mkEnableOption "desktop";

    rdp = {
      enable = lib.mkEnableOption "desktop rdp";
    };
  };

  config = lib.mkIf (cfg.enable) {
    assertions = [
      {
        assertion = config.gui.enable;
        message = "you can't enable this for that reason";
      }
    ];

    gui.fonts.enable = true;

    # security.pam.services.passwd.enableGnomeKeyring = true;

    apps.gpsd.enable = true;

    services = {
      # localtimed.enable = true;

      udev.packages = with pkgs; [
        saleae-logic-2
        nrf-udev
      ];

      dbus = {
        enable = true;
        packages = with pkgs; [
          # custom.anydesk
          # tilix
          usbguard-notifier
          ptyxis
        ];
      };
      # xrdp = mkIf cfg.rdp.enable {
      #   enable = true;
      #   # openFirewall = true;
      # };
      # clipmenu.enable = true;

      systembus-notify.enable = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;

        lowLatency = {
          # enable this module
          enable = true;
        };
      };
      gvfs.enable = true;
    };

    security.polkit = lib.mkIf cfg.rdp.enable {
      enable = true;
      extraConfig = ''
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
      etc."xdg/autostart/geary-autostart.desktop".source = "${pkgs.geary}/share/applications/geary-autostart.desktop";
      sessionVariables.NIXOS_OZONE_WL = "1";
    };
    # chaotic = {
    # scx.enable = true;
    # mesa-git.enable = true;
    # hdr.enable = true;
    # };

    hardware = {
      saleae-logic.enable = true;
      libftdi.enable = true;
      libjaylink.enable = true;
      pulseaudio.enable = false;
      usb-modeswitch.enable = true;
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
      plotinus.enable = true;

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

    boot.extraModulePackages = [config.boot.kernelPackages.akvcam];

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];

    services.gnome = {
      gnome-keyring.enable = false; # true;
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
          pkgs.usbguard-notifier
          #config.system.build.chromium
          pkgs.ptyxis
        ]
        ++ (lib.optional pkgs.stdenv.isx86_64 pkgs.widevine-cdm);
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
