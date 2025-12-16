{
  stdenvNoCC,
  lib,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  pname = "foremost";
  version = "0.0.1";

  src = fetchzip {
    url = "https://drive.usercontent.google.com/download?id=1jTkIWHlrsUACizsRQ7zhwwPUPeefwADb&export=download&authuser=0";
    sha256 = "sha256-Wn90HsvMOk8a8eTHulx9g82S4h+hrx5u3+B8Ekuzxqw=";
    name = "foremost";
    extension = "zip";
    stripRoot = false;
  };

  postInstall = ''
    install -Dm444 *.otf -t $out/share/fonts/otf
    install -Dm444 *.ttf -t $out/share/fonts/ttf
  '';
}
