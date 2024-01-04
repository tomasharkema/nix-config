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
in {
  options.apps.flatpak = {
    enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
  };

  imports = with inputs; [nix-flatpak.nixosModules.nix-flatpak];

  config = mkIf (cfg.enable && !config.traits.slim.enable) {
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
        "org.telegram.desktop"
        "com.moonlight_stream.Moonlight"
      ];
      update.onActivation = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };
    };
  };
}
