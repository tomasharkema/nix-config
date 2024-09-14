{
  stdenvNoCC,
  fetchzip,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "computer-modern";
  version = "1";

  src = fetchzip {
    url = "https://www.fontsquirrel.com/fonts/download/computer-modern";
    stripRoot = false;
    sha256 = "sha256-FC3goqbHKOzxQuM7Wna/4Yg+yygVtR2IdvFjF0BGxlE=";
    extension = "zip";
  };

  # buildPhase = ''
  #     for f in ${fantasqueMonoSansLigatures}/share/fonts/opentype/*; do
  #     python font-patcher $f --complete --no-progressbars --outputdir $out/share/fonts/opentype
  #   done
  # '';

  installPhase = ''
    install -Dm444 *.ttf -t $out/share/fonts/tf
  '';
}
