{
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  nerd-font-patcher,
  undmg,
  xar,
  cpio,
  gzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "san-francisco";
  version = "1";

  nativeBuildInputs = [
    undmg
    nerd-font-patcher
    xar
    gzip
    cpio
  ];

  # src = fetchFromGitHub {
  #   owner = "sahibjotsaggu";
  #   repo = "San-Francisco-Pro-Fonts";
  #   rev = "8bfea09aa6f1139479f80358b2e1e5c6dc991a58";
  #   hash = "sha256-mAXExj8n8gFHq19HfGy4UOJYKVGPYgarGd/04kUIqX4=";
  # };

  # buildPhase = ''
  #     for f in ${fantasqueMonoSansLigatures}/share/fonts/opentype/*; do
  #     python font-patcher $f --complete --no-progressbars --outputdir $out/share/fonts/opentype
  #   done
  # '';

  srcs = [
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
      name = "source-pro.dmg";
      sha256 = "sha256-Lk14U5iLc03BrzO5IdjUwORADqwxKSSg6rS3OlH9aa4=";
    })
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
      name = "source-compact.dmg";
      sha256 = "sha256-CMNP+sL5nshwK0lGBERp+S3YinscCGTi1LVZVl+PuOM=";
    })
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
      sha256 = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
      name = "source-mono.dmg";
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    xar -xf "SF Mono Fonts.pkg"
    cat SFMonoFonts.pkg/Payload | gunzip -dc | cpio -i

    find \( -name \*.ttf -o -name \*.otf \) -execdir nerd-font-patcher -c {} \;

    xar -xf "SF Compact Fonts.pkg"
    cat SFCompactFonts.pkg/Payload | gunzip -dc | cpio -i

    xar -xf "SF Pro Fonts.pkg"
    cat SFProFonts.pkg/Payload | gunzip -dc | cpio -i

    install -Dm444 Library/Fonts/*.otf -t $out/share/fonts/otf
    install -Dm444 Library/Fonts/*.ttf -t $out/share/fonts/ttf

    runHook postInstall
  '';
}
