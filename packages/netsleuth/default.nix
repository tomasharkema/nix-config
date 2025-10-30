{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gettext,
  cmake,
  glib,
  pkg-config,
  python3,
  gtk4,
  appstream,
  desktop-file-utils,
  wrapGAppsHook3,
  gobject-introspection,
}: let
  p = python3.withPackages (ps: with ps; [pygobject3 gst-python]);
in
  stdenv.mkDerivation rec {
    pname = "netsleuth";
    version = "1.1.0";

    src = fetchFromGitHub {
      owner = "vmkspv";
      repo = "netsleuth";
      rev = "v${version}";
      hash = "sha256-jvF8UX9qmf6VyRFFiWD5cGQfUpY2mioS5EGNsslFHQ4=";
    };

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      wrapGAppsHook3
      gobject-introspection
    ];

    buildInputs = [
      gettext
      p
      cmake
      glib
      gtk4
      appstream
      desktop-file-utils
    ];

    meta = with lib; {
      description = "A simple utility for the calculation and analysis of IP subnet values, designed to simplify network configuration tasks";
      homepage = "https://github.com/vmkspv/netsleuth";
      license = licenses.gpl3Only;
      # maintainers = with maintainers; [];
      mainProgram = "netsleuth";
      platforms = platforms.all;
    };
  }
