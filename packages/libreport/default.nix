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
  json_c,
  augeas,
  libarchive,
  newt,
  gtk3,
  copyPkgconfigItems,
  valgrind,
  mt-st,
  autoconf,
  automake,
  libxslt,
  docbook_xsl,
  docbook_xml_dtd_45,
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

  env.NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

  configuraFlags = ["LIBXML=${libxml2.dev}/include/libxml2/libxml"];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    copyPkgconfigItems
    autoconf
    automake
    libxslt
    docbook_xsl
    docbook_xml_dtd_45
    intltool
  ];

  buildInputs = [
    asciidoc
    xmlrpc_c
    xmlto
    glib
    systemd
    libxml2
    curl
    satyr
    elfutils

    json_c
    augeas
    libarchive
    newt
    gtk3
    valgrind
    mt-st
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
