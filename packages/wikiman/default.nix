{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "wikiman";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "filiparag";
    repo = "wikiman";
    rev = version;
    hash = "sha256-gk/9PVIRw9OQrdCSS+LcniXDYNcHUQUxZ2XGQCwpHaI=";
  };

  meta = {
    description = "Wikiman is an offline search engine for manual pages, Arch Wiki, Gentoo Wiki and other documentation";
    homepage = "https://github.com/filiparag/wikiman";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "wikiman";
    platforms = lib.platforms.all;
  };
}
