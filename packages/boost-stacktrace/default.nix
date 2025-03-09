{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  pkg-config,
  libbacktrace,
}:
stdenv.mkDerivation rec {
  pname = "boost-stacktrace";
  version = "1.87.0";

  src = fetchFromGitHub {
    owner = "boostorg";
    repo = "stacktrace";
    rev = "boost-${version}";
    hash = "sha256-iTZfgPHL9toFtXb3zW/AZ+KaQULOiLFFp2v4fRPA4z8=";
  };
  cmakeFlags = [
    "-DBOOST_ROOT=${boost}"

    "-DUSE_STATIC_BOOST=FALSE"
    "-DBoost_DEBUG:BOOL=ON"
  ];
  nativeBuildInputs = [
    cmake
    boost
    pkg-config
    libbacktrace
  ];

  meta = {
    description = "C++ library for storing and printing backtraces";
    homepage = "https://github.com/boostorg/stacktrace";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "boost-stacktrace";
    platforms = lib.platforms.all;
  };
}
