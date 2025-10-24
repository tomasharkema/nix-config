{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
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
  makeWrapper,
  doxygen,
  autoreconfHook,
  autoPatchelfHook,
  wrapGAppsHook,
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
  python = python3.withPackages (ps:
    with ps; [
      dbus-python
      argcomplete
      libreport
      pygobject3
    ]);
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

    preConfigure = ''
      export PYTHONPATH=$(find ${python} -type d -name site-packages)
    '';

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
      # "--prefix=${placeholder "out"}"
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
      # "PREFIX=${placeholder "out"}"
      #"PLUGINS_CONF_DIR=${placeholder "out"}/etc/abrt"
      #"LIBREPORT_PLUGINS_CONF_DIR=${placeholder "out"}/etc/libreport"
      #"CONF_DIR=${placeholder "out"}/etc"
      #"VAR_RUN=${placeholder "out"}/var/run"
      #"EVENTS_CONF_DIR=${placeholder "out"}/etc/libreport/events.d"
      # "dbusabrtconfdir=${placeholder "out"}/share/dbus-1/system.d"
    ];

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      autoreconfHook
      pkg-config
      copyPkgconfigItems
      libxslt
      docbook_xsl
      docbook_xml_dtd_45
      intltool
      doxygen
      python3.pkgs.wrapPython
      wrapGAppsHook
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
      dbus
      # py
      # py.pkgs.sphinx
      python
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

    postInstall = ''
      cp -rv "$out$out/." "$out/"
      rm -rv "$out/nix"
    '';

    postFixup = ''
      for f in "$out/lib/systemd/system"/*; do
        substituteInPlace $f --replace-fail "/usr" "$out"
      done

      wrapPythonProgramsIn "$out/bin" "$out ${libreport} ${python}"

      substituteInPlace "$out/etc/xdg/autostart/org.freedesktop.problems.applet.desktop" \
        --replace-fail "Exec=abrt-applet" "Exec=$out/bin/abrt-applet"

      substituteInPlace "$out/share/dbus-1/system-services/org.freedesktop.problems.service" \
        --replace-fail "/usr" "$out"

      # substituteInPlace "$out/share/dbus-1/services/org.freedesktop.problems.applet.service" \
      #   --replace-fail "/usr" "$out"

      ln -sf $out/bin/abrt $out/bin/abrt-cli
    '';

    postCheck = ''
      file "$out/bin/abrt"
      file "$out/bin/abrtd"
    '';

    passthru = {pythonModule = python;};

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
