{
  lib,
  stdenv,
  fetchzip,
  gettext,
  sources,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-podman";
  version = sources.cockpit-podman;

  src = sources.cockpit-podman;

  nativeBuildInputs = [gettext];

  makeFlags = ["DESTDIR=$(out)" "PREFIX="];

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/share $out/share
    touch pkg/lib/cockpit-po-plugin.js
    touch dist/manifest.json
  '';

  dontBuild = true;

  meta = {
    description = "Cockpit UI for podman containers";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/cockpit-project/cockpit-podman";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [];
  };
}
