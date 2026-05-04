{
  stdenvNoCC,
  fetchzip,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "computer-modern";
  version = "0.7.0";

  src = fetchzip {
    url = "https://sourceforge.net/projects/cm-unicode/files/cm-unicode/${finalAttrs.version}/cm-unicode-${finalAttrs.version}-ttf.tar.xz/download";
    sha256 = "sha256-JNf188eftIS9E6fWXJGnVFj91bXnPwlPkHh7sk6TBno=";
    extension = "tar.xz";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/ttf

    install -Dm444 cm-unicode-${finalAttrs.version}/*.ttf $out/share/fonts/ttf

    runHook postInstall
  '';
})
