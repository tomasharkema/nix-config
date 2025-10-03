{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  libreport,
  systemd,
  autoPatchelfHook,
  makeWrapper,
  tree,
}:
stdenv.mkDerivation rec {
  pname = "reportd";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "abrt";
    repo = "reportd";
    rev = version;
    hash = "sha256-JR5f+xpJfgBtqjegWJO6+V5htnU629agOI0ZZVZDzDw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config

    autoPatchelfHook
    makeWrapper
    # autoreconfHook
  ];

  buildInputs = [
    gobject-introspection
    libreport
    systemd
  ];

  # configureFlags = ["--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"];

  # installFlags = [
  #   "DESTDIR=${placeholder "out"}"
  # ];

  installPhase = ''
    install -D src/reportd $out/libexec/reportd

    install -D systemd/system/reportd.service $out/lib/systemd/system/reportd.service
    install -D systemd/user/reportd.service $out/lib/systemd/user/reportd.service

    install -D dbus/system/org.freedesktop.reportd.service $out/share/dbus-1/system-services/org.freedesktop.reportd.service
    install -D /build/source/dbus/system/org.freedesktop.reportd.conf $out/share/dbus-1/system.d/org.freedesktop.reportd.conf
    install -D dbus/user/org.freedesktop.reportd.service $out/share/dbus-1/services/org.freedesktop.reportd.service
  '';

  meta = {
    description = "Software problem reporting service";
    homepage = "https://github.com/abrt/reportd";
    changelog = "https://github.com/abrt/reportd/blob/${src.rev}/NEWS";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "reportd";
    platforms = lib.platforms.all;
  };
}
#  > Installing /build/source/build/dbus/system/org.freedesktop.reportd.service to /nix/store/vj5s5a3jani20s705dx23g6sbkk9rbvx-reportd-0.7.4/share/dbus-1/system-services
#  > Installing /build/source/dbus/system/org.freedesktop.reportd.conf to /nix/store/vj5s5a3jani20s705dx23g6sbkk9rbvx-reportd-0.7.4/share/dbus-1/system.d
#  > Installing /build/source/build/dbus/user/org.freedesktop.reportd.service to /nix/store/vj5s5a3jani20s705dx23g6sbkk9rbvx-reportd-0.7.4/share/dbus-1/services
#  > Installing /build/source/build/systemd/system/reportd.service to /nix/store/acjdidq41qig9khxcm7gx1d7brzjs249-systemd-257.8/lib/systemd/system
#  > Installation failed due to insufficient permissions.

