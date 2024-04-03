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

    rdp = {
      enable = mkEnableOption "hallo";
    };
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;

        layout = "us";
        xkbVariant = "";

        libinput.enable = true;
      };

      # x2goserver = mkIf cfg.rdp.enable {enable = true;};

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

    # programs.gnupg.agent = {
    # enable = true;
    # enableSSHSupport = true;
    # };
    # services.cpupower-gui.enable = true;

    environment.systemPackages = with pkgs;
      [
        caffeine-ng
        qjournalctl
        pkgs.custom.netbrowse
        gnome.gnome-boxes
        # pcmanfm
        polkit
        gparted
        # firefox
        vscode
        # transmission
        # keybase
        powertop

        nix-software-center
        nixos-conf-editor

        xdg-utils

        # _1password
        # _1password-gui
        # handbrake
        meteo
        # transmission-remote-gtk
        github-desktop

        gtk-engine-murrine
        # plymouth
        rtfm

        effitask
        clutter
        xdgmenumaker
        gotop
        handbrake
        font-manager
        gamehub
        filezilla
        # sublime-merge
        remmina
        xdg-utils
        # mattermost-desktop
        systemdgenie
        # # _1password
        wezterm
        # waybar
        zeal
        mission-center
        pavucontrol
        # libmx
      ]
      ++ optionals pkgs.stdenv.isx86_64 [
        angryipscanner
        telegram-desktop
        pkgs.custom.git-butler
      ]
      ++ (with pkgs.custom; [zerotier-ui zerotier-gui]);

    programs = {
      ssh.extraConfig = ''
        IdentityAgent /home/tomas/.1password/agent.sock
      '';

      ssh = {
        # startAgent = true;
      };

      _1password-gui = {
        enable = true;
        # Certain features, including CLI integration and system authentication support,
        # require enabling PolKit integration on some desktop environments (e.g. Plasma).
        polkitPolicyOwners = ["tomas" "root"];
      };

      firefox = {
        enable = true;

        # nativeMessagingHosts.packages = with pkgs; [gnome-browser-connector];
        # nativeMessagingHosts.gsconnect = true;
      };
      mtr.enable = true;
      # dconf.enable = true;
    };

    # nix.extraOptions = "experimental-features = nix-command flakes";

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
  };
}
