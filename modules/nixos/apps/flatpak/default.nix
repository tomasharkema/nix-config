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
    # xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdg.portal.config.common.default = "gtk";
    services.flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      packages = [
        "com.discordapp.Discord"
        "com.getpostman.Postman"
        "com.github.tchx84.Flatseal"
        "com.logseq.Logseq"
        "com.mattjakeman.ExtensionManager"
        "com.moonlight_stream.Moonlight"
        "com.ranfdev.Notify"
        "com.spotify.Client"
        "io.emeric.toolblex"
        "io.github.JaGoLi.ytdl_gui"
        "io.github.sigmasd.stimulator"
        "io.github.vikdevelop.SaveDesktop"
        "io.missioncenter.MissionCenter"
        "io.podman_desktop.PodmanDesktop"
        "md.obsidian.Obsidian"
        "me.iepure.devtoolbox"
        "org.cockpit_project.CockpitClient"
        "org.fkoehler.KTailctl"
        "org.freefilesync.FreeFileSync"
        "org.gnome.meld"
        "org.stellarium.Stellarium"
        "tv.plex.PlexDesktop"
      ];
      update.onActivation = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };
    };
  };
}
