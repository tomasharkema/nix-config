{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.gui.desktop;

  wsjtx = pkgs.wsjtx.overrideAttrs ({buildInputs, ...}: {
    buildInputs =
      buildInputs
      ++ [
        pkgs.qt5.qtwayland
      ];
  });
in {
  config = lib.mkIf cfg.enable {
    hardware.hackrf.enable = true;

    users.users.tomas.extraGroups = ["plugdev"];

    environment.systemPackages = with pkgs; [
      # keep-sorted start

      # cubicsdr
      gnuradio
      gqrx
      inspectrum
      qradiolink
      sdr-j-fm
      sdrangel
      # sdrplay
      sdrpp
      soapysdr-with-plugins
      wsjtx
      wsjtz
      # dump1090-fa
      # dumphfdl
      # dumpvdl2
      # dumpvdl2
      # dump1090-fa
      # dumphfdl

      # keep-sorted end
    ];
  };
}
