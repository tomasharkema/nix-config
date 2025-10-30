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
    environment.systemPackages = with pkgs; [
      firefox-sync-client
      firefoxpwa
      firefox-unwrapped
    ];

    # programs.firefox = {
    #   enable = true;
    #   package = pkgs.firefox-bin;

    #   preferencesStatus = "default";

    #   nativeMessagingHosts = {
    #     packages = with pkgs; [firefoxpwa];
    #     #   # fxCast = true;
    #     #   # ff2mpv = true;
    #     #   # gsconnect = true;
    #     #   packages = with pkgs; [gnome-browser-connector];
    #   };
    # };
  };
}
