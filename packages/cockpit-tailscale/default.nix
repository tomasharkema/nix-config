{
  lib,
  stdenv,
  fetchzip,
  gettext,
  sources,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-tailscale";
  version = sources.cockpit-tailscale.version;

  src = sources.cockpit-tailscale;

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
