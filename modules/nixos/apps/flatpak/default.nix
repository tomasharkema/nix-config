{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.apps.flatpak;
  enable = cfg.enable && config.gui.enable;
in {
  imports = with inputs; [nix-flatpak.nixosModules.nix-flatpak];

  options.apps.flatpak = {enable = lib.mkEnableOption "flatpak";};

  config = lib.mkIf enable {
    xdg.portal = {
      enable = true;
      config.common.default = "gnome";

      # extraPortals = with pkgs; [
      #   xdg-desktop-portal-kde
      #   xdg-desktop-portal-gtk
      # ];
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
          # "com.termius.Termius"
          "com.gitbutler.gitbutler"
        ]
        ++ (
          lib.optionals pkgs.stdenv.isx86_64
          [
            # "com.discordapp.Discord"
            "com.spotify.Client"
            "tv.plex.PlexDesktop"
          ]
        );

      #  mkIf pkgs.stdenv.isx86_64
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
