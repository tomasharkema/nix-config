{
  lib,
  stdenv,
  fetchurl,
  gettext,
  dpkg,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-dockermanager";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/chrisjbawden/cockpit-dockermanager/releases/download/latest/dockermanager.deb";
    sha256 = "sha256-KgrhP610Iwv8Y4+20TYQquS+TLDPhvD3bjms9e+Q8q0=";
  };

  nativeBuildInputs = [
    gettext
    dpkg
  ];

  makeFlags = ["DESTDIR=$(out)" "PREFIX="];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cockpit/dockermanager
    cp -r ./usr/share/cockpit/dockermanager/. $out/share/cockpit/dockermanager
    ls -la $out/share/cockpit/dockermanager

    runHook postInstall
  '';

  dontBuild = true;

  meta = {
    description = "Cockpit UI for tailscale containers";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/spotsnel/cockpit-tailscale";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [];
  };
}
