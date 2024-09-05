{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.gui.desktop;
in {
  options.gui.desktop = {
    enable = mkEnableOption "hallo";

    rdp = {enable = mkEnableOption "hallo";};
  };

  config = mkIf (cfg.enable) {
    gui.fonts.enable = true;

    security.pam.services.passwd.enableGnomeKeyring = true;

    services = {
      dbus.packages = [pkgs.usbguard-notifier];

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

    security.polkit = mkIf cfg.rdp.enable {
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

    # environment.sessionVariables = {
    #   LD_LIBRARY_PATH = [
    #     # "$LD_LIBRARY_PATH"
    #     "/run/current-system/sw/lib"
    #     "/run/opengl-driver/lib"
    #     "/run/opengl-driver-32/lib"
    #     "${pkgs.custom.openglide}/lib"
    #   ];
    # };

    # chaotic = {
    # scx.enable = true;
    # mesa-git.enable = true;
    # hdr.enable = true;
    # };

    hardware.graphics = {
      enable = true;

      enable32Bit = true;
    };

    programs = {
      evolution.enable = true;
      # geary = {
      #   enable = true;
      # };
    };

    services.gnome.gnome-keyring.enable = true;
    services.gnome.gnome-online-accounts.enable = true;

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
        nix-software-center
        gnomecast
        discordo
        dosbox-x
        go-chromecast

        usbguard-notifier
        usbview
        sqlitebrowser
        boxbuddy
        # notify-client
        # unstable.vscodium
        clutter
        effitask
        filezilla
        font-manager
        fractal
        gamehub
        gotop
        gparted
        grsync
        gtk-engine-murrine
        ktailctl
        libGL
        libGLU
        meteo
        mission-center
        partition-manager
        pavucontrol
        powertop
        pwvucontrol
        qdirstat
        qjournalctl
        rtfm
        spot
        sublime-merge
        sublime4
        transmission-remote-gtk
        trayscale
        tremotesf
        ulauncher
        ventoy-full
        vsce
        vscode
        vte-gtk4

        xdg-utils
        xdgmenumaker
        xdiskusage
        xdotool
        yelp
        zed-editor
      ]
      ++ optionals pkgs.stdenv.isx86_64 [
        gnome_mplayer
        gmtk
        # pkgs.custom.git-butler
        # pkgs.wolfram-engine
        # spotify
        angryipscanner
        bottles
        devdocs-desktop
        dmidecode
        ipmiview
        libsmbios
        config.nur.repos.mloeper.usbguard-applet-qt
        # (plex-media-player.overrideAttrs (prev: {
        #   runtimeDependencies =
        #     prev.runtimeDependencies
        #     ++ [
        #       config.boot.linuxPackages.nvidia_x11
        #     ];
        # }))
        netflix

        plexamp
        xpipe
      ]
      ++ (with pkgs.custom; [
        zerotier-ui
        # ztui

        #netbrowse
        # usbguard-gnome
      ]);

    programs = {
      ssh = {
        # startAgent = true;
      };
      mtr.enable = true;
      dconf.enable = true;

      chromium = {enable = true;};
    };
    systemd.packages = [pkgs.usbguard-notifier];
    # Enable sound with pipewire.
    # sound.enable = mkDefault true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
  };
}
