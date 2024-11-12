{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  autoreconfHook,
  pkg-config,
  python3,
  intltool,
  asciidoc,
  sphinx,
  xmlto,
  glib,
  gtk3,
  systemd,
  libxml2,
  libreport,
  json_c,
  satyr,
  copyPkgconfigItems,
  autoconf,
  automake,
  libsoup_3,
  augeas,
  curl,
  xmlrpc_c,
  libselinux,
  rpm,
  polkit,
  libnotify,
  libxslt,
  docbook_xsl,
  docbook_xml_dtd_45,
  gobject-introspection,
}: let
  sphinxFixed = sphinx.overrideAttrs ({postInstall ? "", ...}: {
    postInstall =
      postInstall
      + ''
        ln -s $out/bin/sphinx-build $out/bin/sphinx-build-3
      '';
  });
in
  stdenv.mkDerivation rec {
    pname = "abrt";
    version = "2.17.6";

    src = fetchFromGitHub {
      owner = "abrt";
      repo = "abrt";
      rev = version;
      hash = "sha256-F8KO7/wdmrkvZTuVO9UKd99fSXduthIeigl3ShTYaqI=";
    };

    env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

    configureFlags = [
      "--sysconfdir=${placeholder "out"}/etc"
      # "-Dsysconfdir_install=${placeholder "out"}/etc"
      # "PYTHON_SPHINX=${sphinx}/bin/sphinx"
      "PYTEST=${python3.pkgs.pytest}/bin/pytest"
    ];

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
      copyPkgconfigItems
      autoconf
      automake
      libxslt
      docbook_xsl
      docbook_xml_dtd_45
      intltool
    ];

    buildInputs = [
      gobject-introspection
      libnotify
      polkit
      rpm
      libselinux
      xmlrpc_c
      libsoup_3
      gettext

      satyr
      json_c
      curl
      augeas
      # py
      # py.pkgs.sphinx
      python3
      python3.pkgs.pytest
      asciidoc
      xmlto
      sphinxFixed
      glib
      gtk3
      systemd
      libxml2
      libreport
    ];

    postPatch = ''
      sh gen-version
    '';

    meta = with lib; {
      description = "Automatic bug detection and reporting tool";
      homepage = "https://github.com/abrt/abrt";
      changelog = "https://github.com/abrt/abrt/blob/${src.rev}/CHANGELOG.md";
      license = licenses.gpl2Only;
      maintainers = with maintainers; [];
      mainProgram = "abrt";
      platforms = platforms.all;
    };
  }
