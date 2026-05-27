{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.gui.desktop;
in {
  config = lib.mkIf cfg.enable {
    hardware.hackrf.enable = true;

    users.users.tomas.extraGroups = ["plugdev"];

    environment.systemPackages = with pkgs; [
      # keep-sorted start
      cubicsdr
      gnuradio
      gqrx
      inspectrum
      qradiolink
      sdr-j-fm
      sdrangel
      sdrplay
      sdrpp
      soapyhackrf
      # keep-sorted end
    ];
  };
}
