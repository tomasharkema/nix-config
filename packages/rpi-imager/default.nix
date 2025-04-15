{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  xz,
  curl,
  gnutls,
  qt6,
  util-linux,
}:
stdenv.mkDerivation rec {
  pname = "rpi-imager";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-imager";
    rev = "v${version}";
    hash = "sha256-7rkoOKG0yMSIgQjqBBFUMgX/4szHn2NXoBR+5PnKlH4=";
  };

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    xz
    gnutls
    curl
    qt6.qtbase
    qt6.full
    util-linux
  ];

  meta = {
    description = "The home of Raspberry Pi Imager, a user-friendly tool for creating bootable media for Raspberry Pi devices";
    homepage = "https://github.com/raspberrypi/rpi-imager";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "rpi-imager";
    platforms = lib.platforms.all;
  };
}
