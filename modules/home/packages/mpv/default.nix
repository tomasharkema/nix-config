{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isLinux) {
    services = {
      plex-mpv-shim.enable = true;
      mpd-mpris.enable = true;
    };

    programs.mpv = {
      enable = true;

      config = {
        video-sync = "display-resample";

        profile = "gpu-hq";
        force-window = true;
        ytdl-format = "bestvideo+bestaudio";
        # cache-default = 4000000;
        hwdec = "auto-safe";
        vo = "gpu";
        gpu-context = "wayland";
      };

      scripts = with pkgs.mpvScripts; [
        mpris
        youtube-upnext
        simple-mpv-webui
        mpv-playlistmanager
        mpv-notify-send
        mpv-cheatsheet
        uosc
        memo
      ];

      scriptOpts = {
        webui = {
          webui-port = 8000;
        };
      };
    };

    home = {
      packages = with pkgs; [
        play-with-mpv
        open-in-mpv
        mpvc
      ];
    };
  };
}
