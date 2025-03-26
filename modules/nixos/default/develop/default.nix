{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [picotool cmakeCurses gcc-arm-embedded gnumake];

    services.udev.packages = with pkgs; [picotool];
  };
}
