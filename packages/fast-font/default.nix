# https://github.com/Born2Root/Fast-Font
{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}:
stdenv.mkDerivation rec {
  pname = "fast-font";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Born2Root";
    repo = "Fast-Font";
    rev = "9523f7096cd7a024bc0098c5bdd9bb35e8ec2d70";
    hash = "sha256-BGCorq2v2jGr49wEZcPcGbGOHzDeyZTO2uPuXtZ2k7o=";
  };

  # buildPhase = ''
  #     for f in ${fantasqueMonoSansLigatures}/share/fonts/opentype/*; do
  #     python font-patcher $f --complete --no-progressbars --outputdir $out/share/fonts/opentype
  #   done
  # '';

  installPhase = ''
    install -D -m 444 *.ttf -t $out/share/fonts/ttf
  '';
}
