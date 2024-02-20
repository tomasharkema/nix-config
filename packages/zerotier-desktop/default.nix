{
  stdenv,
  pkgs,
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  # meson,
}:
rustPlatform.buildRustPackage rec {
  pname = "zerotier-desktop";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "tomasharkema";
    repo = "DesktopUI";
    rev = "ecb71b90f6cf39c9c909f91389e417c04496c50a";
    hash = "sha256-YL0P+1+m8qIppA0BjcIHzSb4F/015AYc2NAvhRKoevc=";
  };

  cargoSha256 = lib.fakeSha256;
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = lib.fakeSha256;
  };
  # cargoLock = rustPlatform.importCargoLock {
  #   lockFileContents = builtins.readFile "${src}/Cargo.lock";
  #   # hash = "";
  # };

  # nativeBuildInputs = with pkgs; [
  #   appstream-glib
  #   polkit
  #   gettext
  #   desktop-file-utils
  #   meson
  #   ninja
  #   pkg-config
  #   git
  #   wrapGAppsHook4
  # ];

  # buildInputs = with pkgs; [
  #   gdk-pixbuf
  #   glib
  #   gtk4
  #   gtksourceview5
  #   libadwaita
  #   libxml2
  #   openssl
  #   wayland
  #   gnome.adwaita-icon-theme
  #   desktop-file-utils
  #   # nixos-appstream-data
  # ];

  meta = with lib; {
    description = "tomas";
    homepage = "https://github.com/tomasharkema/nix-config";
    license = licenses.mit;
    maintainers = ["tomasharkema" "tomas@harkema.io"];
  };
}
