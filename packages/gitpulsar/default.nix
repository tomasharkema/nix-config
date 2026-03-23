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
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitpulsar";
  version = "0.4.3";

  src = fetchFromGitLab {
    owner = "ilshat-apps";
    repo = "gitpulsar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wgvfsWiH4r7NGHp+WyaanxJiukbo5X+4zOHRxeRqLDs=";
  };

  cargoHash = "sha256-7wLYXES2rQeeH7yfxbDBLNYUAJU9WnpvzHIOVxzFCWo=";

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

  meta = {
    description = "A lightweight, GNOME-native Git GUI built with Rust, GTK4, and libadwaita";
    homepage = "https://gitlab.com/ilshat-apps/gitpulsar";
    changelog = "https://gitlab.com/ilshat-apps/gitpulsar/-/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "gitpulsar";
  };
})
