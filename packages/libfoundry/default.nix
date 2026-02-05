{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  cmake,
  pkg-config,
  glib,
  gom,
  libdex,
  fetchurl,
  json-glib,
  libpeas2,
  sysprof,
  libsysprof-capture,
  libxml2,
  libyaml,
  libgit2,
  libssh2,
  template-glib,
  gtksourceview5,
  vte-gtk4,
  cmark,
  webkitgtk_6_0,
  gtk-doc,
  gi-docgen,
  flatpak,
  editorconfig-core-c,
  libspelling,
  validatePkgConfig,
  gobject-introspection,
}: let
  # template-glib_38 = let
  #   version = "3.38.0";
  # in
  #   template-glib.overrideAttrs ({buildInputs ? [], ...}: {
  #     inherit version;
  #     src = fetchurl {
  #       url = "mirror://gnome/sources/template-glib/${lib.versions.majorMinor version}/template-glib-${version}.tar.xz";
  #       hash = "sha256-QNANwiPc8ut/LsQi997FpnNzoMoRAavKD0nGLwUMsxI=";
  #     };
  #     mesonFlags = ["-Ddocs=true"];
  #     buildInputs = buildInputs ++ [gi-docgen];
  #     outputs = [
  #       "out"
  #       "dev"
  #       "doc"
  #     ];
  #   });
in
  stdenv.mkDerivation rec {
    pname = "libfoundry";
    version = "1.0.1";

    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "foundry";
      rev = version;
      hash = "sha256-Lqw9cu7FvZrVjomjjeCXu9bey6/CAS5a0eCZNLrJx50=";
    };

    nativeBuildInputs = [
      meson
      ninja
      cmake
      pkg-config
      glib
      validatePkgConfig
      gobject-introspection
    ];

    propagatedBuildInputs
    #buildInputs
    = [
      gom
      libdex
      json-glib
      libpeas2
      sysprof
      libsysprof-capture
      libxml2
      libyaml
      libgit2
      libssh2
      template-glib
      gtksourceview5
      vte-gtk4
      cmark
      webkitgtk_6_0
      gtk-doc
      flatpak
      editorconfig-core-c
      libspelling
    ];

    meta = {
      description = "Foundry provides a platform for developer tools in GNOME";
      homepage = "https://gitlab.gnome.org/GNOME/foundry";
      changelog = "https://gitlab.gnome.org/GNOME/foundry/-/blob/${src.rev}/NEWS";
      license = lib.licenses.lgpl21Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "foundry";
      platforms = lib.platforms.all;
    };
  }
