{
  lib,
  stdenv,
  fetchzip,
  gettext,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-podman";
  version = "98";

  src = fetchzip {
    url = "https://github.com/cockpit-project/cockpit-podman/releases/download/${version}/cockpit-podman-${version}.tar.xz";
    sha256 = "sha256-pYP7BOk5gdopBlNxhZmMSTgNEz70xq5oKj+ZQMZgr7c=";
  };

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
