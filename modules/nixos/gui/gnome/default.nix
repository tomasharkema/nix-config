{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.gui.gnome;
in
  # pkgsUnstable = inputs.unstable.legacyPackages."${pkgs.system}";
  {
    options.gui.gnome = {
      enable = lib.mkEnableOption "enable gnome desktop environment";

      cursorSize = lib.mkOption {
        type = lib.types.int;
        default = 24;
      };
    };

    config = lib.mkIf cfg.enable {
      # sound.mediaKeys.enable = true;
      traits.developer.enable = lib.mkDefault true;

      system.nixos.tags =
        [
          "gnome"
        ]
        ++ (lib.optional config.gui.hidpi.enable "hidpi");

      environment = {
        etc."X11/Xwrapper.config".text = ''
          allowed_users=anybody
        '';

        # variables = mkIf cfg.hidpi.enable {
        # GDK_SCALE = "2";
        # GDK_DPI_SCALE = "0.5";
        # _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
        # };

        variables.XCURSOR_SIZE = builtins.toString cfg.cursorSize;
        sessionVariables = {
          XCURSOR_SIZE = builtins.toString cfg.cursorSize;
          # NIXOS_OZONE_WL = "1";
        };
        variables.NIXOS_OZONE_WL = "1";
      };

      programs = {
        xwayland.enable = true;

        dconf.profiles = {
          gdm = {
            databases =
              (lib.optional config.gui.hidpi.enable {
                settings."org/gnome/desktop/interface".scaling-factor = lib.gvariant.mkUint32 2;
              })
              ++ [
                {
                  settings."org/gnome/desktop/interface".font-name = "Inter Display 12";
                }
              ];
          };
          tomas.databases = [
            {
              settings."org/gnome/mutter" = {
                experimental-features = [
                  "scale-monitor-framebuffer"
                  "variable-refresh-rate"
                  "rt-scheduler"
                  "xwayland-native-scaling"
                  "kms-modifiers"
                ];
                edge-tiling = true;
              };
              settings."org/gnome/desktop/interface".scaling-factor = lib.gvariant.mkUint32 2;
            }
          ];
        };

        file-roller.enable = true;
        evince.enable = true;

        gnome-disks.enable = true;
        # gnome-terminal.enable = true;
        gpaste.enable = true;
      };

      security.ipa.ifpAllowedUids = ["gdm"];

      # environment.sessionVariables = {
      #   LD_LIBRARY_PATH = [
      #   ];
      # };

      systemd = {
        user.services.polkit-gnome-authentication-agent-1 = {
          description = "polkit-gnome-authentication-agent-1";
          wantedBy = ["graphical-session.target"];
          wants = ["graphical-session.target"];
          after = ["graphical-session.target"];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };

      services = {
        # pipewire.extraConfig.pipewire-pulse."92-tcp" = {
        #   context.modules = [
        #     {
        #       name = "module-native-protocol-tcp";
        #       args = {};
        #     }
        #     {
        #       name = "module-zeroconf-discover";
        #       args = {};
        #     }
        #   ];
        #   stream.properties = {
        #     node.latency = "32/48000";
        #     resample.quality = 1;
        #   };
        # };

        # xrdp.defaultWindowManager = "${pkgs.gnome.gnome-session}/bin/gnome-session";

        xserver = {
          # dpi = mkIf cfg.hidpi.enable 200;

          desktopManager.gnome = {
            enable = true;

            extraGSettingsOverridePackages = with pkgs; [
              mutter
              # gpaste
              custom.usbguard-gnome
              # gnome-menus
              # libusb1
            ];

            extraGSettingsOverrides = ''
              [org.gnome.mutter]
              experimental-features=['scale-monitor-framebuffer', 'kms-modifiers', 'autoclose-xwayland', 'variable-refresh-rate', 'xwayland-native-scaling']
              edge-tiling=true
            '';

            sessionPath = with pkgs; [
              mutter
              gtop
              libgtop
              clutter
              clutter-gtk
              gjs
              gpaste
              libusb1
              gnome-menus
              # pkgs.custom.openglide
              ddcutil
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
          # gnome-browser-connector.enable = true;
          gnome-online-accounts.enable = true;
          glib-networking.enable = true;

          gnome-settings-daemon.enable = true;
          core-shell.enable = true;
          core-utilities.enable = true;
          gnome-user-share.enable = true;
          gnome-keyring.enable = lib.mkForce false; # true;
          games.enable = false;
          evolution-data-server.enable = true;
          rygel.enable = true;
          tracker.enable = true;

          tracker-miners.enable = true;
          gcr-ssh-agent.enable = lib.mkForce false;
          sushi.enable = true;
        };

        # udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
      };

      xdg = {
        autostart.enable = true;
        # portal.wlr.enable = true;
        terminal-exec = {
          enable = true;
          settings = {
            GNOME = [
              "kitty"
            ];
            default = [
              "kitty"
            ];
          };
        };
        icons.enable = true;
        menus.enable = true;
      };

      # services.pipewire.extraConfig.pipewire-pulse."92-tcp" = {
      #   context.modules = [
      #     {
      #       name = "module-native-protocol-tcp";
      #       args = {};
      #     }
      #     {
      #       name = "module-zeroconf-discover";
      #       args = {};
      #     }
      #   ];
      #   stream.properties = {
      #     node.latency = "32/48000";
      #     resample.quality = 1;
      #   };
      # };

      warnings = map (p: "${p.name} disabled") (
        with pkgs; [
          # gnome-extension-manager
          #   gnome-packagekit
          #   gnome-session
          #   gnome-session-ctl
          #   gnome-settings-daemon
          #   gnome-shell-extensions
          #   seahorse
          # gnome-photos
        ]
      );

      environment.systemPackages = with pkgs; [
        adwaita-icon-theme
        clutter
        clutter-gtk
        dconf-editor
        gjs
        gnome-applets
        gnome-autoar
        gnome-clocks
        gnome-commander
        gnome-control-center
        # gnome-extension-managers
        gnome-firmware
        gnome-menus
        gnome-nettool
        # gnome-packagekit
        # gnome-photos
        gnome-session
        gnome-session-ctl
        gnome-settings-daemon
        gnome-shell-extensions
        gnome-themes-extra
        gnome-tweaks
        gnome-user-share
        gtop
        libgnome-keyring
        libgtop
        seahorse
        themix-gui
        wike
        zenity
      ];

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

