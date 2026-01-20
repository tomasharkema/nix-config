{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchgit,
}:
stdenv.mkDerivation rec {
  pname = "wikiman";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "filiparag";
    repo = "wikiman";
    rev = version;
    hash = "sha256-EvYMUHKFJhSFyoW85EEzI7q5OMGGe9c+A2JlkAoxt3o=";
    # fetchSubmodules = true;
  };

  makeFlags = ["prefix=${placeholder "out"}"];

  postInstall = ''
    mv $out/usr/* $out

    substituteInPlace $out/bin/wikiman --replace-fail "/usr/local" "$out"
  '';

  meta = {
    description = "Wikiman is an offline search engine for manual pages, Arch Wiki, Gentoo Wiki and other documentation";
    homepage = "https://github.com/filiparag/wikiman";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "wikiman";
    platforms = lib.platforms.all;
  };
}
