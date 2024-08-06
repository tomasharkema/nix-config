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

    services = {
      libinput.enable = true;

      xserver = {
        enable = true;

        layout = "us";
        # xkbVariant = "";
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
      evolution.enable = false;
      geary.enable = true;
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

    environment.systemPackages =
      (with pkgs; [nix-software-center])
      ++ (with pkgs.unstable;
        [
          apache-directory-studio
          sqlitebrowser
          # notify-client
          # unstable.vscodium
          clutter
          effitask
          filezilla
          font-manager
          fractal
          gamehub
          github-desktop
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
          systemdgenie
          transmission-remote-gtk
          trayscale
          tremotesf
          ulauncher
          ventoy-full
          vsce
          vscode
          vte-gtk4
          wezterm
          xdg-utils
          xdgmenumaker
          xdiskusage
          xdotool
          yelp
          zed-editor
        ]
        ++ optionals pkgs.stdenv.isx86_64 [
          # pkgs.custom.git-butler
          # pkgs.wolfram-engine
          # spotify
          angryipscanner
          bottles
          devdocs-desktop
          discord
          dmidecode
          gitkraken
          handbrake
          ipmiview
          jetbrains-toolbox
          libsmbios
          plex-media-player
          plexamp
          telegram-desktop
          xpipe
          pkgs.custom.ztui
        ]
        ++ (with pkgs.custom; [zerotier-ui netbrowse]));

    programs = {
      ssh = {
        # startAgent = true;
      };

      firefox = {
        enable = true;
        package = pkgs.unstable.firefox;

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
