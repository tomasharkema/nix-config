{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  boost177,
  pkg-config,
  qt5,
  catch2_3,
  imagemagick,
}:
stdenv.mkDerivation rec {
  pname = "denon-control";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ThijsWithaar";
    repo = "DenonControl";
    rev = version;
    hash = "sha256-UQ+mxchVzq1lsHrD7ALsZWkyWxvRhOsKBHDxW6qjkrM=";
  };
  patches = [
    ./fix.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    boost177
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qttools
    catch2_3
    imagemagick
  ];

  cmakeFlags = [
    "-DCATCH_BUILD_TESTING=OFF"
    "-DFETCHCONTENT_SOURCE_DIR_CATCH2_3=${catch2_3}/lib/cmake/Catch2"
  ];

  postInstall = ''ln -s $out/bin/denonUi $out/bin/denon-control'';

  meta = {
    description = "Library and UI for controlling Denon Receivers";
    homepage = "https://github.com/ThijsWithaar/DenonControl";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "denon-control";
    platforms = lib.platforms.all;
  };
}
