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
  enable = cfg.enable && !config.traits.slim.enable && config.gui.enable;
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
        "com.discordapp.Discord"
        "com.getpostman.Postman"
        "com.github.tchx84.Flatseal"
        "com.logseq.Logseq"
        "com.mattjakeman.ExtensionManager"
        "com.moonlight_stream.Moonlight"
        "com.ranfdev.Notify"
        "io.missioncenter.MissionCenter"
        "io.podman_desktop.PodmanDesktop"
        "md.obsidian.Obsidian"
        "me.iepure.devtoolbox"
        "org.cockpit_project.CockpitClient"
        "org.fkoehler.KTailctl"
        "org.gnome.Boxes"
        "org.gnome.meld"
        "org.stellarium.Stellarium"
        "tv.plex.PlexDesktop"
        # "io.github.vikdevelop.SaveDesktop"
      ];
      update.onActivation = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };
    };
  };
}
