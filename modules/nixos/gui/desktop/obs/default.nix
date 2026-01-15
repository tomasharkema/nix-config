{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.gui.desktop;
in {
  config = lib.mkIf cfg.enable {
    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      kernelModules = ["v4l2loopback"];
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
    };
    environment.systemPackages = with pkgs; [
      gphoto2
      v4l-utils
      ffmpeg
    ];

    programs.obs-studio = {
      enable = true;

      enableVirtualCamera = true;

      # optional Nvidia hardware acceleration
      package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi #optional AMD hardware acceleration
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };
}
