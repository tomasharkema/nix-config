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
  darwin,
  alsa-lib,
  openssh,
}:
rustPlatform.buildRustPackage rec {
  pname = "rust-conn";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "totoshko88";
    repo = "RustConn";
    rev = "v${version}";
    hash = "sha256-4TSi7kUOeUe/s1MA6o9Btft3RA+9As7QPIV3XtVIiwY=";
  };

  cargoHash = "sha256-Rm9BxjPN2R+wPQotH+ew9Y5Bhg/I9EwGqYlFXH2FPVU=";

  nativeBuildInputs = [
    pkg-config
    openssh
    wrapGAppsHook4
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
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ]
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
    ];

  meta = {
    description = "Modern connection manager for Linux with GTK4/Wayland-native interface";
    homepage = "https://github.com/totoshko88/RustConn";
    changelog = "https://github.com/totoshko88/RustConn/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "rust-conn";
  };
}
