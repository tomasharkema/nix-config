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

  config = mkIf cfg.enable {
    gui.fonts.enable = true;

    services = {
      libinput.enable = true;

      xserver = {
        enable = true;

        layout = "us";
        # xkbVariant = "";
      };

      xrdp = mkIf cfg.rdp.enable {
        enable = true;
        # openFirewall = true;
      };
      # clipmenu.enable = true;

      systembus-notify.enable = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
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

    hardware.opengl = {
      enable = true;
      extraPackages = [pkgs.mesa.drivers];
    };

    programs = {
      evolution.enable = true;
      geary.enable = false;
    };

    services.dbus = {
      enable = true;
      packages = [pkgs.custom.ancs4linux];
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

    environment.systemPackages = with pkgs;
      (optional ((stdenv.isLinux && stdenv.isx86_64) || stdenv.isDarwin) mailspring)
      ++ [
        yelp
        livecaptions
        pkgs.custom.ancs4linux
        # firefox
        # gnome.gnome-boxes
        # keybase
        # libmx
        # mattermost-desktop
        # nixos-conf-editor
        # pcmanfm
        # plymouth
        # polkit
        # transmission
        # waybar
        # caffeine-ng
        ktailctl
        clutter
        effitask
        filezilla
        font-manager
        gamehub
        github-desktop
        gotop
        gparted
        grsync
        gtk-engine-murrine
        libGL
        libGLU
        meteo
        mission-center
        nix-software-center
        notify-client
        partition-manager
        pavucontrol
        pkgs.custom.netbrowse
        powertop
        pwvucontrol
        qdirstat
        qjournalctl
        remmina
        rtfm
        sublime-merge
        systemdgenie
        tabby
        transmission-remote-gtk
        trayscale
        tremotesf
        vsce
        vscode
        vte-gtk4
        wezterm
        xdg-utils
        xdgmenumaker
        xdiskusage
        xdiskusage
        xdotool
        zeal
      ]
      ++ optionals pkgs.stdenv.isx86_64 [
        gitkraken
        xpipe
        angryipscanner
        telegram-desktop
        # pkgs.custom.git-butler
        bottles

        handbrake
      ]
      ++ (with pkgs.custom; [zerotier-ui]);

    programs = {
      ssh = {
        # startAgent = true;
      };

      firefox = {
        enable = true;

        # nativeMessagingHosts.packages = with pkgs; [gnome-browser-connector];
        # nativeMessagingHosts.gsconnect = true;
      };
      mtr.enable = true;
      dconf.enable = true;
    };

    # Enable sound with pipewire.
    sound.enable = mkDefault true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
  };
}
