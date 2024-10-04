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
  wrapGAppsHook,
  gobject-introspection,
}: let
  p = python3.withPackages (ps: with ps; [pygobject3 gst-python]);
in
  stdenv.mkDerivation rec {
    pname = "netsleuth";
    version = "1.0.2";

    src = fetchFromGitHub {
      owner = "vmkspv";
      repo = "netsleuth";
      rev = "v${version}";
      hash = "sha256-QK1nzMTN6LTFBaFV1TGkaKNIJY3gH0m4QFpAToqkOPI=";
    };

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      wrapGAppsHook
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
      maintainers = with maintainers; [];
      mainProgram = "netsleuth";
      platforms = platforms.all;
    };
  }
