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
        "com.usebottles.bottles"
        "com.moonlight_stream.Moonlight"
        "org.cockpit_project.CockpitClient"
      ];
      update.onActivation = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };
    };
  };
}
