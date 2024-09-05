{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  pkg-config,
  glib,
  libvirt,
  libvirt-glib,
  docutils,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "libvirt-dbus";
  version = "1.4.1";

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-dbus";
    rev = "v${version}";
    sha256 = "sha256-S4QktQmcnTte4XsIcgc5dkA8LjMJaOD2lljS01WT0dk=";
  };

  mesonFlags = [
    "-Dsystem_user=root"
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    docutils
    ninja
  ];
  buildInputs = [
    glib
    libvirt
    libvirt-glib
  ];

  meta = {
    description = "DBus protocol binding for libvirt native C API";
    license = lib.licenses.lgpl2Plus;
    homepage = src.meta.homepage;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [];
  };
}
