{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "surface-pro-12-linux";
  version = "main";

  src = fetchFromGitHub {
    owner = "harrisonvanderbyl";
    repo = "surface-pro-12-inch-linux";
    rev = "4010ca49e14b4b1964e306c51fb9428c2ef79a7c";
    hash = "sha256-+dO+/iEABRq1lmtJmln/X7B/s7AlDkMwEUlzzXhQYO4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -av ./boot $out/
    cp -av ./lib $out/
    cp -av ./usr/share $out/

    runHook postInstall
  '';
}
