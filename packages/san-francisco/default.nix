{
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  nerd-font-patcher,
  undmg,
  xar,
  cpio,
  gzip,
  installFonts,
}:
stdenvNoCC.mkDerivation rec {
  pname = "san-francisco";
  version = "2";

  nativeBuildInputs = [
    undmg
    nerd-font-patcher
    xar
    gzip
    cpio
    installFonts
  ];

  srcs = [
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
      name = "source-pro.dmg";
      sha256 = "0a2bxccfd0191rzd9cfm2arkb723dmkadp3kgiq6ma8z5xifczxj";
    })
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
      name = "source-compact.dmg";
      sha256 = "sha256-byQRcYdqhBdNS5m69Gm6+z+OJFTOoSPYULM/H7D3D18=";
    })
    (fetchurl {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
      name = "source-mono.dmg";
      sha256 = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
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

    # install -Dm444 Library/Fonts/*.otf -t $out/share/fonts/otf
    # install -Dm444 Library/Fonts/*.ttf -t $out/share/fonts/ttf

    installFont otf $out/share/fonts/otf
    installFont ttf $out/share/fonts/ttf


    runHook postInstall
  '';
}
