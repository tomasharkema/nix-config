{
  lib,
  stdenv,
  fetchzip,
  ...
}:
stdenv.mkDerivation rec {
  pname = "neue-haas-grotesk";
  version = "1.001";

  src = fetchzip {
    url = "https://font.download/dl/font/neue-haas-grotesk-display-pro.zip";
    stripRoot = false;
    sha256 = "sha256-13+0MkX2UZa+gHqMqlPLyFMN9wX71EKutFUIqOx4HXA=";
  };

  installPhase = ''
    install -D -m 444 * -t $out/share/fonts/ttf
  '';

  meta = with lib; {
    description = "Christian Schwartz after Max Miedinger ";
    longDescription = ''
      Christian Schwartz after Max Miedinger
    '';
    homepage = "https://www.huertatipografica.com/en/fonts/alegreya-sans-ht";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [tomasharkema];
  };
}
