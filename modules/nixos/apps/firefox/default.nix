{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.apps.firefox;
in {
  options.apps.firefox.enable = mkEnableOption "firefox";

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.unstable.firefox;

      nativeMessagingHosts = {
        gsconnect = true;
        packages = with pkgs; [gnome-browser-connector];
      };
    };
  };
}
