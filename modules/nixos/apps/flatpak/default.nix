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
          "com.getpostman.Postman"
          "com.github.tchx84.Flatseal"
          "io.github.kolunmi.Bazaar"
          # "com.logseq.Logseq"
          # "com.mattjakeman.ExtensionManager"
          #"com.moonlight_stream.Moonlight"
          # "com.ranfdev.Notify"
          #"io.emeric.toolblex"
          "io.github.JaGoLi.ytdl_gui"
          # "io.github.sigmasd.stimulator"
          #"io.github.vikdevelop.SaveDesktop"
          #"io.missioncenter.MissionCenter"
          "me.iepure.devtoolbox"
          "org.cockpit_project.CockpitClient"
          #"org.freefilesync.FreeFileSync"
          #"org.gnome.meld"
          #"com.bitwarden.desktop"
          "io.github.flattool.Warehouse"
          "io.github.plrigaux.sysd-manager"
          "org.raspberrypi.rpi-imager"
        ]
        ++ (
          lib.optionals pkgs.stdenv.isx86_64
          [
            "com.discordapp.Discord"
            "com.spotify.Client"
            "tv.plex.PlexDesktop"
            "com.gitbutler.gitbutler"
            # "org.darktable.Darktable"
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
