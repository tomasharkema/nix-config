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
    url = "https://github.com/spotsnel/cockpit-tailscale/releases/download/v${version}/cockpit-tailscale-v${version}.tar.gz";
    sha256 = "sha256-ESUZdt8GVEToyrv6UP8lOff67LsumdJAY1lXvC3fBaI=";
  };

  nativeBuildInputs = [
    gettext
  ];

  # makeFlags = ["DESTDIR=$(out)" "PREFIX="];

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
