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
    gui.fonts.enable = true;

    security.pam.services.passwd.enableGnomeKeyring = true;

    services = {
      gpsd = {
        enable = true;
      };

      dbus = {
        enable = true;
        packages = with pkgs; [
          # custom.anydesk
          tilix
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
      sessionVariables = {
        # LD_LIBRARY_PATH = [
        #   "/run/current-system/sw/lib"
        #   "/run/opengl-driver/lib"
        #   "/run/opengl-driver-32/lib"
        # ];
      };
    };
    # chaotic = {
    # scx.enable = true;
    # mesa-git.enable = true;
    # hdr.enable = true;
    # };

    # hardware.graphics = {
    #   enable = true;
    #   enable32Bit = pkgs.stdenvNoCC.isx86_64;
    #   extraPackages = with pkgs;
    #     [
    #       mesa
    #       mesa.drivers
    #     ]
    #     ++ lib.optional pkgs.stdenvNoCC.isx86_64 intel-compute-runtime;
    # };

    programs = {
      evolution.enable = false;
      geary.enable = true;
    };

    boot.extraModulePackages = [config.boot.kernelPackages.akvcam];

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];

    services.gnome = {
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };

    networking.firewall = {
      allowedTCPPorts = [
        1900
        5353
        8324
        8080
        8060 # the plex frontend does upnp things
        32433 # plex-media-player
        32410
        32412
        32413
        32414
        32469
      ];
    };

    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs;
      [
        ptyxis
        wl-clipboard-rs
        python312Packages.pyclip
        onioncircuits
        onionshare-gui
        pods
        meld
        pika-backup
        # custom.anydesk
        vlc
        boxbuddy
        clutter
        # dosbox-x
        effitask
        filezilla
        font-manager
        # fractal
        doublecmd
        gamehub
        # gnomecast
        # go-chromecast
        gotop
        gparted
        grsync
        gtk-engine-murrine
        ktailctl
        libGL
        libGLU
        meteo
        mission-center
        # nix-software-center
        partition-manager
        pavucontrol
        powertop
        pwvucontrol
        qdirstat
        qjournalctl
        rtfm
        spot
        sqlitebrowser
        sublime-merge
        sublime4
        transmission-remote-gtk
        trayscale
        tremotesf
        ulauncher
        usbview
        ventoy-full
        vsce
        vte-gtk4
        xdg-utils
        xdgmenumaker
        xdiskusage
        xdotool
        yelp
        f1viewer
        zed-editor
        # ytdlp-gui
      ]
      ++ lib.optionals pkgs.stdenv.isx86_64 [
        # custom.tabby
        jetbrains-toolbox
        synology-drive-client
        # gpt4all-cuda
        _86Box-with-roms
        #       config.boot.linuxPackages.nvidia_x11
        #     ];
        #     ++ [
        #     prev.runtimeDependencies
        #   runtimeDependencies =
        # (plex-media-player.overrideAttrs (prev: {
        # }))
        # handbrake
        # pkgs.custom.git-butler
        # pkgs.wolfram-engine
        # spotify
        # angryipscanner
        bottles
        custom.qlogexplorer
        devdocs-desktop
        # discordo
        dmidecode
        gdm-settings
        # gmtk
        # gnome_mplayer
        ipmiview
        libsmbios
        (plex-media-player.overrideAttrs (old: {
          # cudaSupport = true;
          stdenv = pkgs.cudaPackages.backendStdenv;
        }))
        plexamp
        xpipe
      ]
      ++ (with pkgs.custom; [
        zerotier-ui
        netbrowse
        usbguard-gnome
        sysd-manager
      ]);

    programs = {
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
    };
    systemd = {
      packages =
        [
          pkgs.usbguard-notifier
          config.system.build.chromium
          pkgs.ptyxis
        ]
        ++ (lib.optional pkgs.stdenv.isx86_64 pkgs.widevine-cdm);
    };

    # Enable sound with pipewire.
    # sound.enable = mkDefault true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;

    system.build.chromium = pkgs.chromium.override {
      enableWideVine = pkgs.stdenv.isx86_64;
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    };
  };
}
