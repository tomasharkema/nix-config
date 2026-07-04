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
      # firefox-sync-client
      # firefoxpwa
    ];

    programs.firefox = {
      enable = true; #
      package = pkgs.firefox;

      #preferencesStatus = "default";

      # nativeMessagingHosts.packages = [];

      nativeMessagingHosts = {
        packages = with pkgs; [
          #    firefox-sync-client
          #    firefoxpwas
          # gnome-browser-connector
        ];
      };
    };
  };
}
