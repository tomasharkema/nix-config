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
}:
rustPlatform.buildRustPackage rec {
  pname = "rust-conn";
  version = "0.14.10";

  src = fetchFromGitHub {
    owner = "totoshko88";
    repo = "RustConn";
    rev = "v${version}";
    sha256 = "sha256-LqV8RcQuhZSCRjBxatBEQI5MwD2h3zXd+2h0IDt2TUo=";
  };

  cargoHash = "sha256-Zj8bniA9c0CTkS89Z6XWYVEkDgG2hz9VkPw3gKQi3h0=";
  # postPatch = ''
  #   substituteInPlace Cargo.toml \
  #     --replace-fail 'rust-version = "1.95"' 'rust-version = "1.94"'
  # '';

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
      libadwaita
      openssl
      pango
      vte-gtk4
      zlib
      openssh
    ]
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
    ];

  postInstall = ''
    install -D rustconn/assets/icons/hicolor/scalable/apps/io.github.totoshko88.RustConn.svg $out/share/icons/hicolor/scalable/apps/io.github.totoshko88.RustConn.svg
    install -D rustconn/assets/io.github.totoshko88.RustConn.metainfo.xml $out/share/metainfo/io.github.totoshko88.RustConn.metainfo.xml
    install -D rustconn/assets/io.github.totoshko88.RustConn.desktop $out/share/applications/io.github.totoshko88.RustConn.desktop
  '';

  doCheck = false;

  meta = {
    description = "Modern connection manager for Linux with GTK4/Wayland-native interface";
    homepage = "https://github.com/totoshko88/RustConn";
    changelog = "https://github.com/totoshko88/RustConn/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "rust-conn";
  };
}
