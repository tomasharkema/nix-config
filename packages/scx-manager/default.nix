{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  fmt,
  pkg-config,
  ninja,
  corrosion,
}:
stdenv.mkDerivation rec {
  pname = "scx-manager";
  version = "1.15.9";

  src = fetchFromGitHub {
    owner = "CachyOS";
    repo = "scx-manager";
    rev = "v${version}";
    hash = "sha256-HrWsHI7L9W4UlDfE1f05Y7jWiIiUxiWjg+TqZy8B01I=";
  };
  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_FMT=${fmt}"

    # "-DFETCHCONTENT_SOURCE_DIR_CORROSION=${corrosion}"
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
    ninja
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qttranslations
    fmt
    corrosion
  ];

  meta = {
    description = "Simple GUI for managing sched-ext schedulers via scx_loader";
    homepage = "https://github.com/CachyOS/scx-manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "scx-manager";
    platforms = lib.platforms.all;
  };
}
