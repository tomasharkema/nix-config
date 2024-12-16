{
  pkgs,
  lib,
}:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "LaunchControl";
  version = "2.6.4";

  src = pkgs.fetchurl {
    url = "https://www.soma-zone.com/download/files/LaunchControl-${version}.tar.xz";
    sha256 = "sha256-q0kwcKcrA6tkfd5/wMEjp2zo5UhyNXt/RKRy1YeHwhw=";
  };

  nativeBuildInputs = with pkgs; [xz tree];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R . $out/Applications

    runHook postInstall
  '';

  meta = {
    description = "LaunchControl";
    longDescription = ''
      LaunchControl
    '';
    # homepage = "https://v2.airbuddy.app";
    # changelog = "https://support.airbuddy.app/articles/airbuddy-2-changelog";
    # license = with licenses; [
    # ];
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];

    maintainers = ["tomasharkema" "tomas@harkema.io"];
    platforms = ["aarch64-darwin" "x86_64-darwin"];
  };
}
