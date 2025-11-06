{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
}:
stdenv.mkDerivation rec {
  pname = "qmodbus";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ed-chemnitz";
    repo = "qmodbus";
    rev = "v${version}";
    hash = "sha256-mBwP5zZiMxNo8zKmcVo5XMREt2rQ8A0JtBN179Wf4pM=";
  };

  nativeBuildInputs = with libsForQt5; [
    qt5.qtbase
    qt5.full
    qt5.wrapQtAppsHook
    qt5.qmake
    qt5.qtwayland
  ];

  postInstall = ''
    mkdir $out/bin
    mv $out/qmodbus $out/bin/qmodbus
  '';

  meta = {
    description = "";
    homepage = "https://github.com/ed-chemnitz/qmodbus/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "qmodbus";
    platforms = lib.platforms.all;
  };
}
