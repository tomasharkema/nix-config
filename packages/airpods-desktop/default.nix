{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt5,
  curl,
}: let
  spdlog = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    rev = "5ebfc927306fd7ce551fa22244be801cf2b9fdd9";
    hash = "sha256-k+JguNFg7e2fjZea+WqbmwnU5Tme7kDgGZm3j2k5L7E=";
  };
  cxxopts = fetchFromGitHub {
    owner = "jarro2783";
    repo = "cxxopts";
    rev = "2ad116a9d3297e87e7f6afcb77fbf3dd5d13ff06";
    hash = "sha256-O/b0jpwSsudnHboplCozm/5lZ/lF5ubkgkAjK+meVvw=";
  };
  cpr = fetchFromGitHub {
    owner = "whoshuu";
    repo = "cpr";
    rev = "57e263d7cb7011ebdded3f05109a081cb8b72717";
    hash = "sha256-07S+q8GVAK90j1sSdu/6j3sdE4syi4mGiI2r8SyqdRk=";
  };
in
  stdenv.mkDerivation rec {
    pname = "AirPodsDesktop";
    version = "0.4.1";

    src = fetchFromGitHub {
      owner = "SpriteOvO";
      repo = "AirPodsDesktop";
      rev = "v${version}";
      hash = "sha256-qWZ1RgtkQjdCDCfrdcS/87J/DK7W57nyC/2dquy3wGA=";
    };

    nativeBuildInputs = [cmake pkg-config qt5.wrapQtAppsHook curl];
    buildInputs = [qt5.qtbase qt5.qtmultimedia qt5.qttools curl];

    cmakeFlags = [
      "-DFETCHCONTENT_SOURCE_DIR_SPDLOG=${spdlog}"
      "-DFETCHCONTENT_SOURCE_DIR_CXXOPTS=${cxxopts}"
      "-DFETCHCONTENT_SOURCE_DIR_CPR=${cpr}"
    ];

    enableParallelBuilding = true;
  }
