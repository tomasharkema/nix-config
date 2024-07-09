{
  pkgs,
  lib,
  ...
}:
with lib; {
  config = mkIf pkgs.stdenv.isLinux {
    programs.gnome-shell = {
      enable = true;

      extensions = with pkgs.gnomeExtensions; [
        # {
        #   id = "drive-menu@gnome-shell-extensions.gcampax.github.com";
        #   package = null;
        # }
        # {
        #   id = "GPaste@gnome-shell-extensions.gnome.org";
        #   package = null;
        # }

        {package = thinkpad-thermal;}
        {package = fnlock-switch-thinkpad-compact-usb-keyboard;}
        {package = caffeine;}
        {
          package =
            dash-to-panel;
        }
        # {
        #   package =
        #     executor;
        # }
        {
          package =
            battery-health-charging;
        }
        # {
        #   package =
        #     app-menu-icon-remove-symbolic;
        # }
        # {
        #   package =
        #     pinguxnetlabel;
        # }
        {
          package =
            window-is-ready-remover;
        }
        # {
        #   package =
        #     wayland-or-x11;
        # }
        {
          package =
            appindicator;
        }
        # {
        #   package =
        #     settingscenter;
        # }
        {
          package =
            app-hider;
        }
        {
          package =
            arc-menu;
        }
        {
          package =
            blur-my-shell;
        }
        {
          package =
            extension-list;
        }
        {package = gpu-profile-selector;}
        {
          package =
            hue-lights;
        }
        # {
        #   package =
        #     ip-finder;
        # }
        # {
        #   package =
        #     just-perfection;
        # }
        {
          package =
            kerberos-login;
        }
        # {
        #   package =
        #     logo-menu;
        # }
        {
          package =
            no-overview;
        }
        {
          package =
            remmina-search-provider;
        }
        {
          package =
            removable-drive-menu;
        }
        # {
        #   package =
        #     search-light;
        # }
        # {
        #   package =
        #     server-status-indicator;
        # }
        {
          package =
            tailscale-qs;
        }
        # {
        #   package =
        #     todotxt;
        # }
        # {
        #   package =
        #     tophat;
        # }

        {
          package =
            vitals;
        }
        {
          package =
            pip-on-top;
        }
        # {package = systemd-manager;}
      ];
    };
  };
}
# enabled-extensions = [
#   "app-hider@lynith.dev"
#   "arcmenu@arcmenu.com"
#   "blur-my-shell@aunetx"
#   "caffeine@patapon.info"
#   "dash-to-panel@jderose9.github.com"
#   "display-brightness-ddcutil@themightydeity.github.com"
#   "extension-list@tu.berry"
#   "extensions-search-provider@G-dH.github.com"
#   "gmind@tungstnballon.gitlab.com"
#   "gnome-kinit@bonzini.gnu.org"
#   "GPU_profile_selector@lorenzo9904.gmail.com"
#   "gsconnect@andyholmes.github.io"
#   "hass-gshell@geoph9-on-github"
#   "hue-lights@chlumskyvaclav.gmail.com"
#   "just-perfection-desktop@just-perfection"
#   "mediacontrols@cliffniff.github.com"
#   "monitor-brightness-volume@ailin.nemui"
#   "no-overview@fthx"
#   "pip-on-top@rafostar.github.com"
#   "reboottouefi@ubaygd.com"
#   "remmina-search-provider@alexmurray.github.com"
#   "search-light@icedman.github.com"
#   # "sermon@rovellipaolo-gmail.com"
#   "ssh-search-provider@extensions.gnome-shell.fifi.org"
#   "tailscale-status@maxgallup.github.com"
#   "tailscale@joaophi.github.com"
#   "todo.txt@bart.libert.gmail.com"
#   "toggler@hedgie.tech"
#   "user-theme@gnome-shell-extensions.gcampax.github.com"
#   "Vitals@CoreCoding.com"
#   "vscode-search-provider@mrmarble.github.com"
#   "windowIsReady_Remover@nunofarruca@gmail.com"
#   "systemd-manager@hardpixel.eu"
#   "drive-menu@gnome-shell-extensions.gcampax.github.com"
#   "GPaste@gnome-shell-extensions.gnome.org"
#   # "Airpod-Battery-Monitor@maniacx.github.com"
#   # "dash-to-dock@micxgx.gmail.com"
#   # "github-actions@arononak.github.io"
#   # "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
#   # "lan-ip-address@mrhuber.com"
#   # "logomenu@aryan_k"
#   # "messagingmenu@lauinger-clan.de"
#   # "portforwarding-extension@SJBERTRAND.github.com"
#   # "serverstatus@footeware.ca"
#   # "sp-tray@sp-tray.esenliyim.github.com"
#   # "systemd-manager@hardpixel.eu"
#   # "systemd-status@ne0sight.github.io"
# ];

