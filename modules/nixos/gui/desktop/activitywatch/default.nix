{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.gui.desktop.enable {
    environment.systemPackages = with pkgs; [
      activitywatch
      aw-watcher-window
      aw-qt
      aw-watcher-afk
    ];
  };
}
