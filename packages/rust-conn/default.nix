{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  openssl,
  pango,
  vte-gtk4,
  zlib,
  stdenv,
  alsa-lib,
  openssh,
  copyDesktopItems,
  libsoup_3,
  webkitgtk_6_0,
}:
rustPlatform.buildRustPackage rec {
  pname = "rust-conn";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "totoshko88";
    repo = "RustConn";
    rev = "v${version}";
    sha256 = "sha256-MteZsczCcctDarav36iISO1smH2K44mNAmzSR3f1sPQ=";
  };

  cargoHash = "sha256-KL/6meWDr+6NpeW8eUu70GkrB2LtBt9cmEW4aV54Wcw=";
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    openssh
    wrapGAppsHook4
    copyDesktopItems
  ];

  buildInputs =
    [
      cairo
      gdk-pixbuf
      glib
      gtk4
      openssl
      pango
      vte-gtk4
      zlib
      openssh
      libadwaita
      libsoup_3
      webkitgtk_6_0
    ]
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
    ];

  postInstall =
    if stdenv.isLinux
    then ''
      install -D rustconn/assets/icons/hicolor/scalable/apps/io.github.totoshko88.RustConn.svg $out/share/icons/hicolor/scalable/apps/io.github.totoshko88.RustConn.svg
      install -D rustconn/assets/io.github.totoshko88.RustConn.metainfo.xml $out/share/metainfo/io.github.totoshko88.RustConn.metainfo.xml
      install -D rustconn/assets/io.github.totoshko88.RustConn.desktop $out/share/applications/io.github.totoshko88.RustConn.desktop
    ''
    else ''

    '';

  # doCheck = false;

  meta = {
    description = "Modern connection manager — SSH, RDP, VNC, SPICE, and more ";
    homepage = "https://github.com/totoshko88/RustConn";
    changelog = "https://github.com/totoshko88/RustConn/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "rust-conn";
  };
}
