{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-tailscale";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "spotsnel";
    repo = "cockpit-tailscale";
    rev = "v${version}";
    hash = "sha256-7eZXs/IhhD190LnhGO0i87YZBifG94OkdY+Zlb5xFAI=";
  };

  nativeBuildInputs = [
    gettext
  ];

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
    homepage = "https://github.com/spotsnel/cockpit-tailscale";
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
