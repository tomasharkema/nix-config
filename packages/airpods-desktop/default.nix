{
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt5,
  curl,
  curlpp,
  libcpr,
  boost,
  nix-update-script,
}: let
  spdlog = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    rev = "100f30043f33277122e0991c83845a2617172ffd";
    hash = "sha256-D29jvDZQhPscaOHlrzGN1s7/mXlcsovjbqYpXd7OM50=";
    # fetchSubmodules = true;
  };
  cxxopts = fetchFromGitHub {
    owner = "jarro2783";
    repo = "cxxopts";
    rev = "302302b30839505703d37fb82f536c53cf9172fa";
    hash = "sha256-Ct4MuSn2/pDkmDSkVF/s16+MEGjdpsGomjxATQ85fjQ=";
    # fetchSubmodules = true;
  };
  cpr = fetchFromGitHub {
    owner = "whoshuu";
    repo = "cpr";
    rev = "beb9e98806bb84bcc130a2cebfbcbbc6ce62b335";
    hash = "sha256-9t6ygHI8FbYRs7FcHcPT2OV0z98W6ZyyvoXVkG/AOqc=";
    # fetchSubmodules = true;
  };
  json = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "db78ac1d7716f56fc9f1b030b715f872f93964e4";
    hash = "sha256-THordDPdH2qwk6lFTgeFmkl7iDuA/7YH71PTUe6vJCs=";
    # fetchSubmodules = true;
  };
  singleApplication = fetchFromGitHub {
    owner = "itay-grudev";
    repo = "SingleApplication";
    rev = "bdbb09b5f21ebea4cd7dfb43b29114a94e04a3a1";
    hash = "sha256-WKaIVPEnczto1zQDETDcG+Q54lx7Ds9yNpDTpOkGG7E=";
  };
  magicEnum = fetchFromGitHub {
    owner = "Neargye";
    repo = "magic_enum";
    rev = "3d1f6a5a2a3fbcba077e00ad0ccc2dd9fefc2ca7";
    hash = "sha256-CWGeYzSl2h+Aw/6yMWI0BDPiNq3BFGH3+M9F/ZrKh/Q=";
  };
in
  stdenv.mkDerivation rec {
    pname = "AirPodsDesktop";
    version = "0.4.1";

    src = fetchFromGitHub {
      owner = "SpriteOvO";
      repo = "AirPodsDesktop";
      rev = "${version}";
      hash = "sha256-JhwwWQ5ec5dc46RE46PbvpBkO7HDMYX/qzzCngIyjjg=";
      # fetchSubmodules = true;
    };

    nativeBuildInputs = [
      cmake
      pkg-config
      qt5.wrapQtAppsHook
      curl
      extra-cmake-modules
      # boost
    ];

    buildInputs = [
      qt5.qtbase
      qt5.qtmultimedia
      qt5.qttools
      curl
      curlpp
      libcpr
      boost
    ];

    cmakeFlags = [
      "-DFETCHCONTENT_SOURCE_DIR_SPDLOG=${spdlog}"
      "-DFETCHCONTENT_SOURCE_DIR_CXXOPTS=${cxxopts}"
      "-DFETCHCONTENT_SOURCE_DIR_CPR=${cpr}"
      "-DFETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON=${json}"
      "-DFETCHCONTENT_SOURCE_DIR_SINGLEAPPLICATION=${singleApplication}"
      "-DFETCHCONTENT_SOURCE_DIR_MAGIC_ENUM=${magicEnum}"
      "-DCPR_USE_SYSTEM_CURL=ON"
      "-DCPR_FORCE_USE_SYSTEM_CURL=ON"
      "-DUSE_STATIC_BOOST=false"
    ];

    enableParallelBuilding = true;

    passthru = {
      updateScript = nix-update-script {};
    };
  }
