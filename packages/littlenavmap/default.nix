{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  libsForQt5,
  pkg-config,
  atools,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "littlenavmap";
  version = "3.0.18";

  src = fetchFromGitHub {
    owner = "albar965";
    repo = "littlenavmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8D4Kh+DZbTxgzX2LVTHNRVHCCZq81Fmcspjbrur5FbQ=";
  };
  env = {
    ATOOLS_INC_PATH = "${atools}/include";
    ATOOLS_LIB_PATH = "${atools}/lib";
    DEPLOY_BASE = "${placeholder "out"}";
  };
  # qmakeFlags = [""];

  buildInputs = [libsForQt5.qtbase atools];
  nativeBuildInputs = [libsForQt5.wrapQtAppsHook libsForQt5.qmake pkg-config];

  meta = {
    description = "Little Navmap is a free flight planner, navigation tool, moving map, airport search and airport information system for Flight Simulator X, Microsoft Flight Simulator 2020, Prepar3D and X-Plane";
    homepage = "https://github.com/albar965/littlenavmap";
    changelog = "https://github.com/albar965/littlenavmap/blob/${finalAttrs.src.rev}/CHANGELOG.txt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "littlenavmap";
    platforms = lib.platforms.all;
  };
})
