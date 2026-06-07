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

  wsjtz = pkgs.wsjtz.overrideAttrs rec {
    version = "2.0.14";

    src = pkgs.fetchFromGitHub {
      owner = "sq9fve";
      repo = "wsjt-z";
      rev = "v${version}";
      sha256 = "sha256-pgOGNA/EpyEj9qu61cbZsjv9sKDYKvNpfe8FBAcHkM8=";
    };
  };
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
      soapysdr-with-plugins
      wsjtx
      wsjtz
      # keep-sorted end
    ];
  };
}
