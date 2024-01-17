{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}:
stdenv.mkDerivation rec {
  name = "b612-font-2019-01-21";

  src = fetchFromGitHub {
    owner = "polarsys";
    repo = "b612";
    rev = "48ac6ba67ecab8123e8e36d6aa05367db0c7b638";
    hash = "sha256-wR8/mWp9fj0Zyhf0b7IdKik9f11qngcvxbCpMbFTMUc=";
  };

  nativeBuildInputs = [pkgs.nerd-font-patcher];

  # buildPhase = ''
  #   # find -name \*.ttf -o -name \*.otf -exec nerd-font-patcher -out nf -c {} \;
  # '';
  buildPhase = ":";

  installPhase = ''
    mkdir -p $out/share/fonts
    cp ./fonts/ttf/*.ttf $out/share/fonts
  '';

  meta = {
    homepage = "http://b612-font.com/";
    platforms = lib.platforms.all;
    license = lib.licenses.epl10;
    maintainers = [lib.maintainers.grahamc];
  };
}
