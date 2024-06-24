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

    # services = {
    #   tabby.enable = true;
    # };

    # environment.variables = {
    #   LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:/run/opengl-driver/lib:/run/opengl-driver-32/lib";
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

    environment.systemPackages = with pkgs;
      [
        mailspring
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
        handbrake
        handbrake
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
        xpipe
        angryipscanner
        telegram-desktop
        # pkgs.custom.git-butler
        bottles
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

    # nix.extraOptions = "experimental-features = nix-command flakes";

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;

    # boot.binfmt.registrations.appimage = {
    #   wrapInterpreterInShell = false;
    #   interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    #   recognitionType = "magic";
    #   offset = 0;
    #   mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
    #   magicOrExtension = "\\x7fELF....AI\\x02";
    # };
  };
}
