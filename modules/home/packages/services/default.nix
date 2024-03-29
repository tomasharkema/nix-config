{
  pkgs,
  lib,
  ...
}:
with lib; {
  config = mkIf pkgs.stdenv.isLinux {
    services = {
      pbgopy.enable = true;
      unclutter.enable = true;
      systembus-notify.enable = true;
      status-notifier-watcher.enable = true;
      poweralertd.enable = true;
      pueue.enable = true;
      polybar.enable = true;
      playerctld.enable = true;
    };
  };
}
