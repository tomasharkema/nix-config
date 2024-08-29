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
      sha256 = "sha256-B8xljBAqOoRFXvSOkOKDDWeYUebtMmQLJ8lF05iFnXk=";
      name = "source-pro.dmg";
    })
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
      sha256 = "sha256-L4oLQ34Epw1/wLehU9sXQwUe/LaeKjHRxQAF6u2pfTo=";
      name = "source-compact.dmg";
    })
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
      sha256 = "sha256-Uarx1TKO7g5yVBXAx6Yki065rz/wRuYiHPzzi6cTTl8=";
      name = "source-mono.dmg";
    })
  ];

  sourceRoot = ".";

  installPhase = ''

    xar -xf "SF Mono Fonts.pkg"
    cat SFMonoFonts.pkg/Payload | gunzip -dc | cpio -i

    find \( -name \*.ttf -o -name \*.otf \) -execdir nerd-font-patcher -c {} \;

    xar -xf "SF Compact Fonts.pkg"
    cat SFCompactFonts.pkg/Payload | gunzip -dc | cpio -i

    xar -xf "SF Pro Fonts.pkg"
    cat SFProFonts.pkg/Payload | gunzip -dc | cpio -i

    install -D -m 666 Library/Fonts/*.otf -t $out/share/fonts/otf
    install -D -m 666 Library/Fonts/*.ttf -t $out/share/fonts/ttf

  '';
}
