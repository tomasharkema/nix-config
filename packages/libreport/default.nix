{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  intltool,
  asciidoc,
  xmlto,
  xmlrpc_c,
  glib,
  systemd,
  libxml2,
  curl,
  satyr,
  elfutils,
}:
stdenv.mkDerivation rec {
  pname = "libreport";
  version = "2.17.15";

  src = fetchFromGitHub {
    owner = "abrt";
    repo = "libreport";
    rev = version;
    hash = "sha256-XGsdEVODKC81ejMHaETdt1Vt7x4PQfxhfabKuEuHONA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    intltool
    asciidoc
    xmlrpc_c
    xmlto
    glib
    systemd
    libxml2
    curl
    satyr
    elfutils
  ];

  postPatch = ''
    sh gen-version
  '';

  meta = with lib; {
    description = "Generic library for reporting various problems";
    homepage = "https://github.com/abrt/libreport";
    changelog = "https://github.com/abrt/libreport/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [];
    mainProgram = "libreport";
    platforms = platforms.all;
  };
}
