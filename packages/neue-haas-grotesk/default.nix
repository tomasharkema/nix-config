{
  stdenvNoCC,
  fetchzip,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "neue-haas-grotesk";
  version = "1.001";

  src = fetchzip {
    url = "https://font.download/dl/font/neue-haas-grotesk-display-pro.zip";
    stripRoot = false;
    sha256 = "sha256-13+0MkX2UZa+gHqMqlPLyFMN9wX71EKutFUIqOx4HXA=";
  };

  # buildPhase = ''
  #     for f in ${fantasqueMonoSansLigatures}/share/fonts/opentype/*; do
  #     python font-patcher $f --complete --no-progressbars --outputdir $out/share/fonts/opentype
  #   done
  # '';

  installPhase = ''
    install -Dm444 *.ttf -t $out/share/fonts/ttf
  '';
}
