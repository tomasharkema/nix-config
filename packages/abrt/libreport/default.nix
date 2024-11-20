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
  dbus,
  autoPatchelfHook,
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

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

  configureFlags = [
    "LIBXML=${libxml2.dev}/include/libxml2/libxml"
    "--prefix=${placeholder "out"}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--sharedstatedir=/var/lib"
    "--libdir=${placeholder "out"}/lib"
    "--libexecdir=${placeholder "out"}/libexec"
    "--bindir=${placeholder "out"}/bin"
    "--sbindir=${placeholder "out"}/sbin"
    "--includedir=${placeholder "out"}/include"
    "--mandir=${placeholder "out"}/share/man"
    "--infodir=${placeholder "out"}/share/info"
    "--localedir=${placeholder "out"}/share/locale"
  ];

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX=${placeholder "out"}"
  ];

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
    autoPatchelfHook
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
    dbus
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

  postInstall = ''
    cp -rv "$out$out/." "$out/"
    rm -rv "$out/nix"
  '';

  postCheck = ''
    file $out/bin/reporter-upload
    file $out/bin/reporter-print
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
