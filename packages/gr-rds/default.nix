{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gnuradio,
  spdlog,
  gmp,
  boost,
  volk,
  python3,
  pkg-config,
}: let
  py = python3.withPackages (ps: with ps; [pybind11 numpy]);
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "gr-rds";
    version = "3.10";

    src = fetchFromGitHub {
      owner = "bastibl";
      repo = "gr-rds";
      tag = "v${finalAttrs.version}";
      hash = "sha256-86hPAUjdApCMCNPlt79ShNIuZrtc73O0MxTjgTuYo+U=";
    };

    nativeBuildInputs =
      [
        cmake
        pkg-config
        python3.pkgs.pybind11
      ]
      ++ gnuradio.pythonPkgs;

    buildInputs = [
      gmp
      gnuradio
      spdlog
      boost
      volk
    ];

    meta = {
      description = "FM RDS/TMC Transceiver";
      homepage = "https://github.com/bastibl/gr-rds";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "gr-rds";
      platforms = lib.platforms.all;
    };
  })
