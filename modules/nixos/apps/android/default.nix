{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.android;
in {
  options.apps.android = {
    enable = mkBoolOpt false "Android enable";
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;

    users.users."tomas".extraGroups = ["adbusers"];
    environment.systemPackages = with pkgs; [android-studio android-tools];
  };
}
