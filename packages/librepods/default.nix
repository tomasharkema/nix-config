{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6Packages,
  cmake,
  ninja,
  pkg-config,
  openssl,
  pulseaudioFull,
}:
stdenv.mkDerivation rec {
  pname = "librepods";
  version = "0.1.0-rc.4";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    rev = "main";
    hash = "sha256-vWtBSHYPtrSmYzY25a1RcVUlpaXF2WzNLke7RiST/38=";
  };

  sourceRoot = "${src.name}/linux";

  nativeBuildInputs = [
    pkg-config
    cmake
    # ninja
  ];

  buildInputs = [
    # qt6Packages.qtbase
    qt6Packages.wrapQtAppsHook
    qt6Packages.qtquick3d
    qt6Packages.qtdeclarative
    qt6Packages.qtmultimedia
    qt6Packages.qtquicktimeline
    qt6Packages.qtconnectivity
    qt6Packages.qtwayland
    openssl
    pulseaudioFull
  ];

  meta = {
    description = "AirPods liberated from Apple's ecosystem";
    homepage = "https://github.com/kavishdevar/librepods";
    changelog = "https://github.com/kavishdevar/librepods/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "librepods";
    platforms = lib.platforms.all;
  };
}
