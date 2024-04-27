# {
#   lib,
#   fetchFromGitHub,
#   jre,
#   makeWrapper,
#   maven,
#   tree,
#   javaPackages,
# }:
# maven.buildMavenPackage rec {
#   pname = "astounding";
#   version = "0.3";
#   src = fetchFromGitHub {
#     owner = "jlarriba";
#     repo = pname;
#     rev = "${version}";
#     hash = "sha256-czwyWWDXJVGjwSsqZlblktLaqjmgpxF6Spj0DapSoqw=";
#   };
#   mvnHash = "sha256-tOP0dCuOiM9H1TrEd9psJ51Jp2Y7bTu2boeV/inTCvE=";
#   nativeBuildInputs = [
#     makeWrapper
#     javaPackages.openjfx21
#   ];
#   installPhase = ''
#     ${tree}/bin/tree
#     mkdir -p $out/bin $out/share/astounding
#     install -Dm644 target/astounding-${version}.jar $out/share/astounding
#     makeWrapper ${jre}/bin/java $out/bin/astounding \
#       --add-flags "-jar $out/share/astounding/astounding-${version}.jar"
#   '';
#   # meta = {
#   #   description = "Simple command line wrapper around JD Core Java Decompiler project";
#   #   homepage = "https://github.com/intoolswetrust/jd-cli";
#   #   license = lib.licenses.gpl3Plus;
#   #   maintainers = with lib.maintainers; [majiir];
#   # };
# }
{
  tree,
  lib,
  openjdk11,
  stdenv,
  makeWrapper,
  fetchurl,
  javaPackages,
  gtk3,
  wrapGAppsHook,
  patchelf,
  openjfx21,
}: let
  jdk = openjdk11.override {enableJavaFX = true;};
  extraLdPath = [gtk3];
in
  stdenv.mkDerivation rec {
    pname = "astounding";
    version = "0.3";

    executable = fetchurl {
      url = "https://github.com/jlarriba/astounding/releases/download/${version}/astounding.jar";
      hash = "sha256-SpaCtV5TQM1miGxHWxcHZ04LTTLwJ662Etsj8AGwoew=";
    };

    phases = ["installPhase"];

    nativeBuildInputs = [
      patchelf
      makeWrapper
      javaPackages.openjfx11
      wrapGAppsHook
      gtk3
    ];
    buildInputs = [jdk openjfx21];
    installPhase = ''
      mkdir -p $out/bin $out/share/astounding
      install -Dm644 ${executable} $out/share/astounding/astounding.jar
      makeWrapper ${jdk}/bin/java $out/bin/astounding \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extraLdPath}" \
        --add-flags "-jar $out/share/astounding/astounding.jar"
    '';
    passthru = {inherit jdk;};
  }
