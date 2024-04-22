{
  lib,
  stdenv,
  fetchzip,
  gettext,
  git,
  nodejs,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-ostree";
  version = "201";

  src = fetchzip {
    url = "https://github.com/cockpit-project/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-aFXQrKI68L5rbzul4jRDQDkA/wdCEkyIqVfJU/yJG24=";
  };

  nativeBuildInputs = [
    gettext
    git
    nodejs
  ];

  makeFlags = ["DESTDIR=$(out)" "PREFIX="];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "~/.local/share/cockpit" $out/share
    touch pkg/lib/cockpit-po-plugin.js
    touch dist/manifest.json
  '';

  # dontBuild = true;

  meta = with lib; {
    description = "Cockpit UI for ostree containers";
    license = licenses.lgpl21;
    homepage = "https://github.com/cockpit-project/cockpit-ostree";
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
