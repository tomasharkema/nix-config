{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  tree,
}:
stdenv.mkDerivation rec {
  pname = "sscom";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "kangear";
    repo = "sscom";
    rev = "76ac49c7200b70a3fa538dd6852db23039394ddd";
    hash = "sha256-NxzTg5/Y3odhTq+v9n+3v4X5DiPKSAxdx5S8xXbpigY=";
  };

  nativeBuildInputs = with libsForQt5; [
    qt5.wrapQtAppsHook
    qt5.qmake
  ];

  buildInputs = with libsForQt5; [
    qt5.qtbase
    qt5.qtserialport
    qt5.qtwayland
  ];

  postInstall = ''
    install -D sscom $out/bin/sscom
  '';

  meta = {
    description = "Linux sscom";
    homepage = "https://github.com/kangear/sscom";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [];
    mainProgram = "sscom";
    platforms = lib.platforms.all;
  };
}
