{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.gui.apps.flatpak;
  enable = cfg.enable && !config.traits.slim.enable;
in {
  imports = with inputs; [nix-flatpak.nixosModules.nix-flatpak];

  options.gui.apps.flatpak = {
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
        "io.missioncenter.MissionCenter"
        "com.mattjakeman.ExtensionManager"
        "com.moonlight_stream.Moonlight"
        "org.cockpit_project.CockpitClient"
        "com.discordapp.Discord"
        "com.github.tchx84.Flatseal"
        # "io.github.vikdevelop.SaveDesktop"
        "tv.plex.PlexDesktop"
        "org.stellarium.Stellarium"
        "org.gnome.Boxes"
        "com.ranfdev.Notify"
        "com.getpostman.Postman"
        "org.gnome.meld"
        "io.podman_desktop.PodmanDesktop"
        "com.discordapp.Discord"
        "com.logseq.Logseq"
        "md.obsidian.Obsidian"
      ];
      # update.onActivation = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };
    };
  };
}
