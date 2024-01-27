{
  lib,
  pkgs,
  config,
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
      gnome = {
        chrome-gnome-shell.enable = true;
        gnome-browser-connector.enable = true;
      };

      xserver = {
        enable = true;

        layout = "us";
        xkbVariant = "";

        libinput.enable = true;
        desktopManager.gnome.enable = true;

        displayManager = {
          gdm.enable = true;

          lightdm = {
            greeters.gtk = {
              enable = true;

              theme = {
                name = "Catppuccin-Mocha-Compact-Blue-Dark";
                package = pkgs.catppuccin-gtk.override {
                  accents = ["blue"];
                  size = "compact";
                  tweaks = ["rimless" "black"];
                  variant = "mocha";
                };
              };
            };
          };
        };
      };

      xrdp = mkIf cfg.rdp.enable {
        enable = true;
        openFirewall = true;
        defaultWindowManager = "${pkgs.gnome.gnome-session}/bin/gnome-session";
      };

      systembus-notify.enable = true;
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

    programs.mtr.enable = true;
    # programs.gnupg.agent = {
    # enable = true;
    # enableSSHSupport = true;
    # };

    environment.systemPackages = with pkgs;
      [
        polkit
        gparted
        # firefox
        vscode
        fira-code-nerdfont
        transmission
        # keybase
        powertop

        nix-software-center
        # nixos-conf-editor

        gnome-firmware
        gnome.gnome-session
        gnome.gnome-settings-daemon
        gnome.gnome-shell-extensions
        gnome.gnome-tweaks
        gnome.gnome-nettool
        gnome.gnome-keyring
        gnome.gnome-control-center
        gnome.dconf-editor

        gnome-menus
        xdg-utils

        # _1password
        # _1password-gui
        handbrake
        meteo
        transmission-remote-gtk
        github-desktop

        gnome-menus
        gtk-engine-murrine
        plymouth
        # apache-directory-studio
      ]
      ++ optional (pkgs.system == "x86_64-linux") telegram-desktop;

    programs = {
      ssh.extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';

      _1password-gui = {
        enable = true;
        # Certain features, including CLI integration and system authentication support,
        # require enabling PolKit integration on some desktop environments (e.g. Plasma).
        polkitPolicyOwners = ["tomas" "tomas@harkema.io"];
      };

      firefox = {
        enable = true;

        # nativeMessagingHosts.packages = with pkgs; [gnome-browser-connector];
        # nativeMessagingHosts.gsconnect = true;
      };
    };

    # nix.extraOptions = "experimental-features = nix-command flakes";

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #    media-session.enable = true;
    };

    services.gvfs.enable = true;

    boot.hardwareScan = true;
  };
}
