{
  lib,
  stdenv,
  fetchzip,
  gettext,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-podman";
  version = "90";

  src = fetchzip {
    url = "https://github.com/cockpit-project/cockpit-podman/releases/download/${version}/cockpit-podman-${version}.tar.xz";
    sha256 = "sha256-xKVXxKJGVLuBPxJMc6YN2xSke2Ww79UuDbQjH1yNH7o=";
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

  meta = with lib; {
    description = "Cockpit UI for podman containers";
    license = licenses.lgpl21;
    homepage = "https://github.com/cockpit-project/cockpit-podman";
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
