{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  libgit2,
  oniguruma,
  openssl,
  pango,
  zlib,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitpulsar";
  version = "0.6.0";

  src = fetchFromGitLab {
    owner = "ilshat-apps";
    repo = "gitpulsar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m8qGTV4eBH7Js6ldOsLfYpdS8/McOPtgeFuUx5rh/mg=";
  };

  cargoHash = "sha256-/3x8wVgChqvrLx8fBcxGZ33SUoRT2umCYl/d0GVeYGc=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    libgit2
    oniguruma
    openssl
    pango
    zlib
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A lightweight, GNOME-native Git GUI built with Rust, GTK4, and libadwaita";
    homepage = "https://gitlab.com/ilshat-apps/gitpulsar";
    changelog = "https://gitlab.com/ilshat-apps/gitpulsar/-/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "gitpulsar-gtk";
  };
})
