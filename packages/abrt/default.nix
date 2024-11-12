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
  dbus,
  util-linux,
  doxygen,
}: let
  sphinxFixed = sphinx.overrideAttrs (
    {postInstall ? "", ...}: {
      postInstall =
        postInstall
        + ''
          ln -s $out/bin/sphinx-build $out/bin/sphinx-build-3
        '';
    }
  );
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

    enableParallelBuilding = true;

    env.NIX_CFLAGS_COMPILE = toString [
      "-I${glib.dev}/include/gio-unix-2.0"
    ];

    # patches = [./dbus.patch];
    # makeFlags = "DESTDIR=${placeholder "out"}";

    configureFlags = [
      "PYTEST=${python3.pkgs.pytest}/bin/pytest"
      "FINDMNT=${util-linux}/bin/findmnt"
      #"PLUGINS_CONF_DIR=${placeholder "out"}/etc/abrt"
      #"LIBREPORT_PLUGINS_CONF_DIR=${placeholder "out"}/etc/libreport"
      #"EVENTS_CONF_DIR=${placeholder "out"}/etc/libreport/events.d"
      #"VAR_RUN=${placeholder "out"}/var/run"
      #"CONF_DIR=${placeholder "out"}/etc"
      # "-Dsysconfdir_install=${placeholder "out"}/etc"
      "PYTHON_SPHINX=${sphinx}/bin/sphinx"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
      "--sharedstatedir=/var/lib"
      # "--prefix=${placeholder "out"}"
      # "--libdir=${placeholder "out"}/lib"
      # "--libexecdir=${placeholder "out"}/libexec"
      # "--bindir=${placeholder "out"}/bin"
      # "--sbindir=${placeholder "out"}/sbin"
      # "--includedir=${placeholder "out"}/include"
      # "--mandir=${placeholder "out"}/share/man"
      # "--infodir=${placeholder "out"}/share/info"
      # "--localedir=${placeholder "out"}/share/locale"
      #"--with-dbusabrtconfdir=${placeholder "out"}/share/dbus-1/system.d"
      #"--with-dbusinterfacedir=${placeholder "out"}/share/dbus-1/interfaces"
      #"--with-augeaslenslibdir=${augeas}/share/augeas/lenses"
      "--without-selinux"
      #"--with-autostartdir=${placeholder "out"}/etc/xdg/autostart"
    ];
    installFlags = [
      "DESTDIR=${placeholder "out"}"
      "PREFIX=${placeholder "out"}"
      #"PLUGINS_CONF_DIR=${placeholder "out"}/etc/abrt"
      #"LIBREPORT_PLUGINS_CONF_DIR=${placeholder "out"}/etc/libreport"
      #"CONF_DIR=${placeholder "out"}/etc"
      #"VAR_RUN=${placeholder "out"}/var/run"
      #"EVENTS_CONF_DIR=${placeholder "out"}/etc/libreport/events.d"
      # "dbusabrtconfdir=${placeholder "out"}/share/dbus-1/system.d"
    ];

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
      copyPkgconfigItems
      libxslt
      docbook_xsl
      docbook_xml_dtd_45
      intltool
      doxygen
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
      dbus
      satyr
      json_c
      curl
      augeas
      # py
      # py.pkgs.sphinx
      python3
      python3.pkgs.pytest
      python3.pkgs.dbus-python

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

    postInstall = ''
      cp -rv "$out$out/." "$out/"
      rm -rv "$out/nix"

      for i in "$out/lib/systemd/system"/*; do
        substituteInPlace $i --replace-fail "/usr" "$out"
      done

      file $out/bin/abrtd
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
