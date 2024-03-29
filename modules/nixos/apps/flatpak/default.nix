{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.flatpak;
  enable = cfg.enable && !config.traits.slim.enable && config.gui.enable;
in {
  imports = with inputs; [nix-flatpak.nixosModules.nix-flatpak];

  options.apps.flatpak = {
    enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
  };

  config = mkIf enable {
    xdg.portal = {
      enable = true;
      config.common.default = "gnome";
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
          #"com.getpostman.Postman"
          "com.github.tchx84.Flatseal"
          # "com.logseq.Logseq"
          # "com.mattjakeman.ExtensionManager"
          #"com.moonlight_stream.Moonlight"
          # "com.ranfdev.Notify"
          #"io.emeric.toolblex"
          "io.github.JaGoLi.ytdl_gui"
          "io.github.sigmasd.stimulator"
          #"io.github.vikdevelop.SaveDesktop"
          #"io.missioncenter.MissionCenter"
          "me.iepure.devtoolbox"
          "org.cockpit_project.CockpitClient"
          "org.fkoehler.KTailctl"
          #"org.freefilesync.FreeFileSync"
          #"org.gnome.meld"
          #"com.bitwarden.desktop"
        ]
        ++ (
          if pkgs.stdenv.isx86_64
          then [
            "com.discordapp.Discord"
            "com.spotify.Client"
            "tv.plex.PlexDesktop"
            "com.heroicgameslauncher.hgl"
          ]
          else []
        );
      update.onActivation = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };
    };
  };
}
