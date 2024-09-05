# https://github.com/dropbox/nautilus-dropbox
{
  lib,
  stdenv,
  fetchFromGitHub,
  gnome-common,
  autoconf,
  automake,
  libtool,
  pkg-config,
  python3,
  docutils,
  nautilus-python,
  nautilus,
  glib,
  gobject-introspection,
}: let
  p = python3.withPackages (ps:
    with ps; [
      setuptools
      distlib
      distutils-extra
      pygobject3
    ]);
in
  stdenv.mkDerivation rec {
    pname = "nautilus-dropbox";
    version = "2024.04.17";

    src = fetchFromGitHub {
      owner = "dropbox";
      repo = "nautilus-dropbox";
      rev = "v${version}";
      hash = "sha256-9wQznMsj8IL0JHBF96yVgI6r25jW8unr/UJeSGv1DBw=";
    };

    preConfigure = ''
      ./autogen.sh
    '';
    makeFlags = ["DESTDIR=$(out)" "PREFIX="];

    buildInputs = [
      gnome-common
      nautilus-python
      nautilus
      docutils
      glib
      gobject-introspection
    ];
    nativeBuildInputs = [
      autoconf
      automake
      libtool
      pkg-config
      p
    ];
  }
