{
  lib,
  stdenv,
  fetchFromGitea,
  meson,
  ninja,
  gettext,
  desktop-file-utils,
  blueprint-compiler,
  pkg-config,
  cmake,
  python3,
  gtk4,
  gobject-introspection,
  wrapGAppsHook3,
  webkitgtk_6_0,
}: let
  py = python3.withPackages (ps:
    with ps; [
      gobject-introspection
      pygobject3
      pypandoc
      weasyprint
    ]);
in
  stdenv.mkDerivation rec {
    pname = "letters";

    version = "0.2.0";
    pyproject = false;

    src = fetchFromGitea {
      domain = "codeberg.org";
      owner = "eyekay";
      repo = "letters";
      rev = version;
      hash = "sha256-hgGAUjX9Fh4PKDpeS6ydimZHIXhtEaD87WvI76RpQ/0=";
    };

    nativeBuildInputs = [
      meson
      ninja
      desktop-file-utils
      blueprint-compiler
      pkg-config
      cmake
      gtk4
      # gobject-introspection
      wrapGAppsHook3
      webkitgtk_6_0
      py
    ];

    buildInputs = [
      gettext
    ];

    meta = {
      description = "Word processor for GNOME";
      homepage = "https://codeberg.org/eyekay/letters";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "letters";
      platforms = lib.platforms.all;
    };
  }
