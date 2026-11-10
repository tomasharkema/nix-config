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
  nix-update-script,
  aws-lc,
}:
rustPlatform.buildRustPackage rec {
  pname = "rust-conn";
  version = "0.24.8";

  src = fetchFromGitHub {
    owner = "totoshko88";
    repo = "RustConn";
    rev = "v${version}";
    sha256 = "sha256-LeKYQ9I3Y3NrYJ+XrPA/+tAkU+ZF+e9KN9YFPzo4nVs=";
  };

  cargoHash = "sha256-sifegTUMN/+0wHQLLfOPSJGxrdgT+WOOiLe8U/SkzUQ=";
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    openssh
    wrapGAppsHook4
    copyDesktopItems
  ];

  buildInputs =
    [
      aws-lc
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
    else "";

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Modern connection manager — SSH, RDP, VNC, SPICE, and more ";
    homepage = "https://github.com/totoshko88/RustConn";
    changelog = "https://github.com/totoshko88/RustConn/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "rust-conn";
  };
}
