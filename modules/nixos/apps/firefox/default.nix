{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.firefox;
in {
  options.apps.firefox.enable = lib.mkEnableOption "firefox";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;

      nativeMessagingHosts = {
        fxCast = true;
        ff2mpv = true;
        gsconnect = true;
        packages = with pkgs; [gnome-browser-connector];
      };
    };
  };
}
