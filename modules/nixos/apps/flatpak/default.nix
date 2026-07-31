{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.apps.flatpak;
in {
  options.apps.flatpak = {
    enable =
      (lib.mkEnableOption "flatpak")
      // {
        default = config.gui.enable;
      };
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      # config.common.default = "gnome";
      xdgOpenUsePortal = true;

      extraPortals = with pkgs; [
        # xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };

    services.flatpak = {
      enable = true;

      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
        # {
        #   name = "appcenter";
        #   location = "https://flatpak.elementary.io/repo.flatpakrepo";
        # }
      ];

      packages =
        [
          # keep-sorted start
          "com.getpostman.Postman"
          "com.github.tchx84.Flatseal"
          # "com.logseq.Logseq"
          # "com.mattjakeman.ExtensionManager"
          #"com.moonlight_stream.Moonlight"
          # "com.ranfdev.Notify"
          #"io.emeric.toolblex"
          "io.github.JaGoLi.ytdl_gui"
          "io.github.flattool.Warehouse"
          #"org.freefilesync.FreeFileSync"
          #"org.gnome.meld"
          #"com.bitwarden.desktop"
          "io.github.josephmawa.EncodingExplorer"
          "io.github.kolunmi.Bazaar"
          "io.github.plrigaux.sysd-manager"
          "io.scottlabs.reManager"
          # "io.github.sigmasd.stimulator"
          #"io.github.vikdevelop.SaveDesktop"
          #"io.missioncenter.MissionCenter"
          "me.iepure.devtoolbox"
          "org.cockpit_project.CockpitClient"
          "org.meshtastic.MeshtasticDesktop"
          "org.raspberrypi.rpi-imager"
          # keep-sorted end
        ]
        ++ (
          lib.optionals pkgs.stdenvNoCC.hostPlatform.isx86_64
          [
            # keep-sorted start
            "com.discordapp.Discord"
            # "tv.plex.PlexDesktop"
            "com.gitbutler.gitbutler"
            # "org.darktable.Darktable"
            # keep-sorted end
          ]
        );

      update = {
        onActivation = true;

        auto = {
          enable = true;
          onCalendar = "daily"; # Default value
        };
      };
    };
  };
}
