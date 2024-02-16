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
  version = "200";

  src = fetchzip {
    url = "https://github.com/cockpit-project/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-94GgJeiHU7KEiSi7gqVAyjmNlrhNkwcyUm+VmBRuGs8=";
  };

  nativeBuildInputs = [
    gettext
    git
    nodejs
  ];

  makeFlags = ["DESTDIR=$(out)" "PREFIX="];

  postPatch = ''
    ls -la
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
