{
  pkgs,
  lib,
}:
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "LaunchControl";
  version = "2.5.5";

  src = pkgs.fetchurl {
    url = "https://www.soma-zone.com/download/files/LaunchControl-${version}.tar.xz";
    sha256 = "sha256-sCK1JN7xM9gHpd2ad5kki9TVMFwWLdo4apzQNDbmOVc=";
  };

  nativeBuildInputs = with pkgs; [xz tree];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R . $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "LaunchControl";
    longDescription = ''
      LaunchControl
    '';
    # homepage = "https://v2.airbuddy.app";
    # changelog = "https://support.airbuddy.app/articles/airbuddy-2-changelog";
    # license = with licenses; [
    # ];
    sourceProvenance = with sourceTypes; [binaryNativeCode];

    maintainers = ["tomasharkema" "tomas@harkema.io"];
    platforms = ["aarch64-darwin" "x86_64-darwin"];
  };
}
