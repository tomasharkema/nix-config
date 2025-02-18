{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "zide";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "josephschmitt";
    repo = "zide";
    rev = "v${version}";
    hash = "sha256-CqpqkGdsEGZ5IeuZD87ONlN68MkTgip9SNnsxzQ1YGk=";
  };

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp -r bin/* $out/bin/
    cp -r layouts $out/
  '';

  meta = {
    description = "Group of configuration files and scripts to create an IDE-like experience in zellij";
    homepage = "https://github.com/josephschmitt/zide";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "zide";
    platforms = lib.platforms.all;
  };
}
