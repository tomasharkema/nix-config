{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  gettext,
  glib,
  glibc,
  cmake,
  pkg-config,
  python3,
  git,
  gtk4,
  libadwaita,
  gobject-introspection,
  wrapGAppsHook,
  libshumate,
  desktop-file-utils,
}: let
  py = python3.withPackages (ps:
    with ps; [
      glib
      gobject-introspection
      pygobject3
      meshtastic
      pyqrcode
    ]);
in
  stdenv.mkDerivation rec {
    pname = "gtk-meshtastic-client";
    version = "1.2";

    src = fetchFromGitLab {
      owner = "kop316";
      repo = "gtk-meshtastic-client";
      rev = version;
      hash = "sha256-P0U3OO1BSysGGMGADPVREWoJqcKeZITla91iIdV7y4M=";
    };

    nativeBuildInputs = [
      #python3.pkgs.setuptools
      meson
      ninja
      gobject-introspection
      wrapGAppsHook
      pkg-config
      desktop-file-utils
      py
    ];
    buildInputs = [
      libshumate
      gettext
      glib
      glibc
      cmake

      git
      gtk4
      libadwaita
    ];

    #preInstall = ''
    #  makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    #'';

    meta = {
      description = "";
      homepage = "https://gitlab.com/kop316/gtk-meshtastic-client";
      changelog = "https://gitlab.com/kop316/gtk-meshtastic-client/-/blob/${src.rev}/Changelog";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "gtk-meshtastic-client";
      platforms = lib.platforms.all;
    };
  }
