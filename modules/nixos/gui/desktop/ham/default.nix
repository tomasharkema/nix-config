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

      # soapysdr-with-plugins

      custom.ut61b
      # cubicsdr
      # gnuradio
      gqrx
      inspectrum
      # qradiolink
      sdr-j-fm
      sdrangel
      # sdrplay
      sdrpp
      wsjtx
      # wsjtz
      # dump1090-fa
      # dumpvdl2
      # dumphfdl
      # keep-sorted end
    ];

    services.udev.packages = with pkgs; [
      custom.ut61b
    ];
  };
}
