{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "toolblex";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "emericg";
    repo = "toolBLEx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EjOqKcimYcdplCu3xP2gdT30IrMS3Z23OcXY7QqRgRw=";
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtcharts
    qt6.qtconnectivity
  ];

  meta = {
    description = "Bluetooth Low Energy (and Classic) device scanner and analyzer";
    homepage = "https://github.com/emericg/toolBLEx";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [fgaz];
    mainProgram = "toolBLEx";
    platforms = lib.platforms.all;
  };
})
