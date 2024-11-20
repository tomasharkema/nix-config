{
  lib,
  stdenv,
  fetchzip,
  gettext,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-tailscale";
  version = "0.0.6";

  src = fetchzip {
    sha256 = "18h5vwnvqmsrcd0d569fpgngmxrr4pzm1ymvrbl48m06vxv1j98i";
    url = "https://github.com/spotsnel/cockpit-tailscale/releases/download/v${version}/cockpit-tailscale-v${version}.tar.gz";
  };

  nativeBuildInputs = [
    gettext
  ];

  makeFlags = ["DESTDIR=$(out)" "PREFIX="];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cockpit/tailscale
    cp -r . $out/share/cockpit/tailscale
    ls -la $out/share/cockpit/tailscale

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
