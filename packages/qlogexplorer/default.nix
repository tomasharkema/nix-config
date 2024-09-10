{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt5,
}:
stdenv.mkDerivation rec {
  pname = "qlogexplorer";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "rafaelfassi";
    repo = "qlogexplorer";
    rev = "v${version}";
    hash = "sha256-b+drdsXrY43DiJHLR3zE5lvQfTjClwF7rKGrFDxiWDY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    qt5.qtbase
  ];

  meta = {
    description = "Advanced and fast log explorer with support to JSON files and columns";
    homepage = "https://github.com/rafaelfassi/qlogexplorer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "qlogexplorer";
    platforms = lib.platforms.all;
  };
}
