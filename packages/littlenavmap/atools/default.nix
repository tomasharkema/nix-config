{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  pkg-config,
  cpptrace,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "atools";
  version = "4.0.18";

  src = fetchFromGitHub {
    owner = "albar965";
    repo = "atools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EY611n/MCCKVXy+eUVhBpEGVcw5kwUsNeyhCRrj1sOo="; # "sha256-7p2oAyBNhOjMaTwrGlM93cIq1CleeYkDc5UyMyN2Fog=";
  };

  env.DEPLOY_BASE = "/build/source/out";

  # qmakeFlags = ["DEPLOY_BASE=${placeholder "out"}/lib"];
  buildInputs = [
    cpptrace
    libsForQt5.qtbase
  ];

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    libsForQt5.qmake
    pkg-config
  ];

  postBuild = ''
    make deploy
  '';

  postInstall = ''
    mkdir -p $out
    cp -va /build/source/outD/atools/lib $out
    cp -va /build/source/outD/atools/include $out
  '';

  meta = {
    description = "Atools is a static library extending Qt for exception handling, a log4j like logging framework, Flight Simulator related utilities like BGL reader and more";
    homepage = "https://github.com/albar965/atools";
    changelog = "https://github.com/albar965/atools/blob/${finalAttrs.src.rev}/CHANGELOG.txt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "atools";
    platforms = lib.platforms.all;
  };
})
