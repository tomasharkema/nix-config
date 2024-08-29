{
  stdenvNoCC,
  fetchzip,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "din";
  version = "1";

  src = fetchzip {
    url = "https://www.fontsquirrel.com/fonts/download/d-din";
    stripRoot = false;
    sha256 = "sha256-W1/7hA/LFF3KI7CU6pFGcywkMmdGzjeAqK0eKC/O/QQ=";
    extension = "zip";
  };

  # buildPhase = ''
  #     for f in ${fantasqueMonoSansLigatures}/share/fonts/opentype/*; do
  #     python font-patcher $f --complete --no-progressbars --outputdir $out/share/fonts/opentype
  #   done
  # '';

  installPhase = ''
    install -D -m 666 *.otf -t $out/share/fonts/otf
  '';
}
