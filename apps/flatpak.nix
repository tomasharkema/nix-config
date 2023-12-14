{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs) stdenv;
in {
  services."flatpak" = {
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
}
