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

    systemd.user.services.activitywatch = {
      path = [pkgs.activitywatch];
      script = "exec aw-qt";
      description = "activitywatch tray-icon";
      restartTriggers = ["on-failure"];
      wantedBy = ["graphical-session.target"];
    };
  };
}
