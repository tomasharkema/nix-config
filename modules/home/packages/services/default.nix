{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isLinux) {
    services = {
      pbgopy.enable = true;
      unclutter.enable = true;
      systembus-notify.enable = true;
      status-notifier-watcher.enable = true;
      poweralertd.enable = true;
      pueue.enable = true;
      polybar = {
        enable = true;
        script = "polybar bar &";
        extraConfig = ''
          [module/date]
          type = internal/date
          interval = 5
          date = "%d.%m.%y"
          time = %H:%M
          format-prefix-foreground = \''${colors.foreground-alt}
          label = %time%  %date%
        '';
      };
      playerctld.enable = true;
      notify-osd.enable = true;
      mpd = {
        enable = true;
        musicDirectory = "/home/tomas/Music";
      };
      mbsync.enable = true;
      mopidy.enable = true;
    };
  };
}
