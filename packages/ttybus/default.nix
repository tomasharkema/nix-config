{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "ttybus";
  version = "unstable-2021-03-22";

  src = fetchFromGitHub {
    owner = "danielinux";
    repo = "ttybus";
    rev = "1108a9476964baea5eb6dbb6973cd24238c77f44";
    hash = "sha256-JqxhQIuNVQLbHmyUhJhIOJNn5cZsBdg5le6cP6vSEdY=";
  };

  makeFlags = ["PREFIX=$(out)"];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = {
    description = "A simple TTY multiplexer";
    homepage = "https://github.com/danielinux/ttybus";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "ttybus";
    platforms = lib.platforms.all;
  };
}
