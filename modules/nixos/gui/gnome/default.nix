{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.gui.gnome;
in
  # pkgsUnstable = inputs.unstable.legacyPackages."${pkgs.system}";
  {
    options.gui.gnome = {
      enable = mkEnableOption "enable gnome desktop environment";

      hidpi.enable = mkEnableOption "enable gnome desktop environment";
    };

    config = mkIf cfg.enable {
      sound.mediaKeys.enable = true;
      traits.developer.enable = mkDefault true;

      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      # programs.hyprland = {
      #   # Install the packages from nixpkgs
      #   enable = true;
      #   # Whether to enable XWayland
      #   xwayland.enable = true;
      # };

      programs = {
        xwayland.enable = true;

        dconf.profiles = {
          # gdm = mkIf cfg.hidpi.enable {
          #   databases = [{
          #     settings."org/gnome/desktop/interface".scaling-factor =
          #       lib.gvariant.mkUint32 2;
          #   }];
          # };
          tomas.databases = [
            {
              settings."org/gnome/mutter" = {
                experimental-features = [
                  "scale-monitor-framebuffer"
                  "variable-refresh-rate"
                ];
                edge-tiling = true;
              };
              #   settings."org/gnome/desktop/interface".scaling-factor =
              #     lib.gvariant.mkUint32 2;
            }
          ];
        };

        file-roller.enable = true;
        evince.enable = true;

        gnome-disks.enable = true;
        gnome-terminal.enable = true;
        gpaste.enable = true;
      };

      environment.etc."X11/Xwrapper.config".text = ''
        allowed_users=anybody
      '';

      security.ipa.ifpAllowedUids = ["gdm"];

      services = {
        xrdp.defaultWindowManager = "${pkgs.gnome.gnome-session}/bin/gnome-session";

        xserver = {
          desktopManager.gnome = {
            enable = true;

            extraGSettingsOverridePackages = with pkgs; [
              gnome.mutter
              gnome.gpaste
              # gnome-menus
            ];

            extraGSettingsOverrides = ''
              [org.gnome.mutter]
              experimental-features=['scale-monitor-framebuffer', 'variable-refresh-rate']
              edge-tiling=true
            '';

            sessionPath = with pkgs; [
              gnome.mutter
              gtop
              libgtop
              clutter
              clutter-gtk
              gjs
              gnome.gpaste
              gnome-menus
            ];
          };

          displayManager = {
            gdm = {
              enable = true;
              wayland = true;
              # nvidiaWayland = true;
            };
          };
        };
        libinput.enable = true;
        gnome = {
          # chrome-gnome-shell.enable = true;
          gnome-browser-connector.enable = true;
          gnome-online-accounts.enable = true;
          glib-networking.enable = true;

          gnome-settings-daemon.enable = true;
          core-shell.enable = true;
          core-utilities.enable = true;
          gnome-user-share.enable = true;
          gnome-keyring.enable = true;
          games.enable = false;
          evolution-data-server.enable = true;
          rygel.enable = true;
          tracker.enable = true;

          tracker-miners.enable = true;

          sushi.enable = true;
        };

        # udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
      };

      xdg = {
        autostart = {
          enable = true;
        };
        # portal.wlr.enable = true;
        terminal-exec = {
          enable = true;
          settings = {
            default = ["kitty.desktop"];
          };
        };
        icons.enable = true;
        menus.enable = true;
      };

      services.pipewire.extraConfig.pipewire-pulse."92-tcp" = {
        context.modules = [
          {
            name = "module-native-protocol-tcp";
            args = {};
          }
          {
            name = "module-zeroconf-discover";
            args = {};
          }
        ];
        stream.properties = {
          node.latency = "32/48000";
          resample.quality = 1;
        };
      };
      environment.systemPackages =
        (with pkgs; [
          wike
          gtop
          libgtop
          gnome-extension-manager
          gnome-menus
          gnomeExtensions.dash-to-panel
          gnomeExtensions.executor
          gnomeExtensions.battery-health-charging
          gnomeExtensions.app-menu-icon-remove-symbolic
          gnomeExtensions.pinguxnetlabel
          gnomeExtensions.window-is-ready-remover
          gnomeExtensions.wayland-or-x11
          # gnomeExtensions.network-interfaces-info
          gnomeExtensions.appindicator
          gnomeExtensions.settingscenter
          gnomeExtensions.app-hider
          gnomeExtensions.arc-menu
          gnomeExtensions.blur-my-shell
          gnomeExtensions.clipboard-indicator
          gnomeExtensions.dash-to-dock
          gnomeExtensions.extension-list
          # gnomeExtensions.fuzzy-app-search
          gnomeExtensions.github-actions
          # gnomeExtensions.gpu-profile-selector
          gnomeExtensions.hue-lights
          gnomeExtensions.ip-finder
          gnomeExtensions.just-perfection
          gnomeExtensions.kerberos-login
          gnomeExtensions.logo-menu
          gnomeExtensions.no-overview
          gnomeExtensions.remmina-search-provider
          gnomeExtensions.removable-drive-menu
          gnomeExtensions.search-light
          gnomeExtensions.server-status-indicator
          gnomeExtensions.tailscale-qs
          gnomeExtensions.todotxt
          gnomeExtensions.tophat
          gnomeExtensions.no-title-bar
          gnomeExtensions.vitals
          gnomeExtensions.pip-on-top
          gnomeExtensions.systemd-manager
        ])
        ++ (with pkgs; [
          clutter
          clutter-gtk
          gjs
          gnome.adwaita-icon-theme
          gnome-firmware
          gnome-menus
          gnome.dconf-editor
          gnome.gnome-applets
          gnome.gnome-autoar
          gnome.gnome-clocks
          gnome.gnome-control-center
          gnome.gnome-keyring
          gnome.gnome-nettool
          gnome.gnome-online-miners
          # gnome.gnome-packagekit
          gnome.gnome-power-manager
          gnome.gnome-session
          gnome.gnome-session-ctl
          gnome.gnome-settings-daemon
          gnome.gnome-shell-extensions
          gnome.gnome-themes-extra
          gnome.gnome-tweaks
          gnome.gnome-user-share
          gnome.libgnome-keyring
          gnome.seahorse
          gnome.zenity
        ]);

      # services.synergy.client = {
      #   enable = true;
      #   serverAddress = "euro-mir";
      # };

      # environment.gnome.excludePackages =
      #   (with pkgs; [
      #     # gnome-photos
      #     gnome-tour
      #   ])
      #   ++ (with pkgs.gnome; [
      #     aisleriot
      #     four-in-a-row
      #     five-or-more
      #     swell-foop
      #     lightsoff
      #     quadrapassel

      #     gnome-chess
      #     gnome-klotski
      #     gnome-mahjongg
      #     gnome-nibbles
      #     gnome-tetravex
      #     gnome-robots
      #     gnome-taquin

      #     cheese # webcam tool
      #     tali # poker game
      #     iagno # go game
      #     hitori # sudoku game
      #     atomix # puzzle game
      #     yelp # Help view
      #     gnome-initial-setup
      #   ]);
    };
  }
# # pkgs.gnome45Extensions."app-hider@lynith.dev"
# gnome45Extensions."gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
# # gnome45Extensions."gsconnect@andyholmes.github.io"
# gnome45Extensions."gnome-kinit@bonzini.gnu.org"
# gnome45Extensions."lan-ip-address@mrhuber.com"
# gnome45Extensions."no-overview@fthx"
# gnome45Extensions."reboottouefi@ubaygd.com"
# gnome45Extensions."tailscale@joaophi.github.com"
# # gnome45Extensions."todo.txt@bart.libert.gmail.com"
# gnome45Extensions."toggler@hedgie.tech"
# gnome45Extensions."appindicatorsupport@rgcjonas.gmail.com"
# # gnome45Extensions."extension-list@tu.berry"
# # gnome45Extensions."GPU_profile_selector@lorenzo9904.gmail.com"
# # gnome45Extensions."messagingmenu@lauinger-clan.de"
# # gnome45Extensions."serverstatus@footeware.ca"
# # gnome45Extensions."sp-tray@sp-tray.esenliyim.github.com"
# gnome45Extensions."user-theme@gnome-shell-extensions.gcampax.github.com"
# gnome45Extensions."Vitals@CoreCoding.com"
# gnome45Extensions."monitor-brightness-volume@ailin.nemui"
# # gnome45Extensions."systemd-status@ne0sight.github.io"
# gnomeExtensions.spotify-tray

