{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isLinux {
    services = {
      # pbgopy.enable = true;
      # unclutter.enable = true;
      systembus-notify.enable = true;
      status-notifier-watcher.enable = true;
      # poweralertd.enable = true;
      pueue.enable = true;

      playerctld.enable = osConfig.gui.enable;

      # mpd = {
      #   enable = osConfig.gui.enable;
      #   musicDirectory = "/home/tomas/Music";
      # };

      # mbsync.enable = osConfig.gui.enable;
    };
  };
}
