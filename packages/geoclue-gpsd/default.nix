{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
  json-glib,
  cmake,
  libsoup_3,
  modemmanager,
  avahi,
  dbus,
  dbus-glib,
  gpsd,
  gobject-introspection,
  vala,
  gettext,
  libnotify,
  gtk-doc,
  docbook_xsl,
  withDemoAgent ? false,
}:
stdenv.mkDerivation rec {
  pname = "geoclue-gpsd";
  version = "unstable-2024-05-28";

  src = fetchFromGitHub {
    owner = "FakeShell";
    repo = "geoclue-gpsd";
    rev = "b9666e4f8c5a9e12306671c74793030ab0707f15";
    hash = "sha256-NPFkMjQ4VcOSp4m+dIoevb5Ch7v1O3E0P5uZPiuFhy8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    glib
    json-glib
    cmake
    libsoup_3
    modemmanager
    avahi
    dbus
    dbus-glib
    gpsd
    vala
    gettext
    libnotify
    gtk-doc

    # docbook_xml_dtd_45
    docbook_xsl
    # docbook-xsl-nons
  ];

  meta = {
    description = "";
    homepage = "https://github.com/FakeShell/geoclue-gpsd";
    changelog = "https://github.com/FakeShell/geoclue-gpsd/blob/${src.rev}/NEWS";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "geoclue-gpsd";
    platforms = lib.platforms.all;
  };
}
