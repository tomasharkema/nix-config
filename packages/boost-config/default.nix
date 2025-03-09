{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "boost-config";
  version = "1.79.0";

  src = fetchFromGitHub {
    owner = "boostorg";
    repo = "config";
    rev = "boost-${version}";
    hash = "sha256-6rboedIsYk/Rz+1Mmpb+TIEjiDlqv9C1qhwRjK40dh0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    boost
    pkg-config
  ];

  meta = {
    description = "Boost.org config module";
    homepage = "https://github.com/boostorg/config";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "boost-config";
    platforms = lib.platforms.all;
  };
}
