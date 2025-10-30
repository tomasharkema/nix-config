{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  python3,
  cmake,
  pkg-config,
  abrt,
  libreport,
  glib,
  libadwaita,
  asciidoc,
  xmlto,
  libxslt,
  docbook_xsl,
  docbook_xml_dtd_45,
  intltool,
  doxygen,
  gobject-introspection,
  wrapGAppsHook3,
  autoPatchelfHook,
}: let
  python = python3.withPackages (ps:
    with ps; [
      pygobject3
      gst-python
      abrt
      libreport
      humanize
      beautifulsoup4
      dbus-python
    ]);
in
  stdenv.mkDerivation rec {
    pname = "gnome-abrt";
    version = "1.5.2";

    src = fetchFromGitHub {
      owner = "abrt";
      repo = "gnome-abrt";
      rev = version;
      hash = "sha256-YdWXKtcaGR3x59xvPnTsIer+7wz6qZVzDR7nNP69fsc=";
    };

    enableParallelBuilding = true;

    nativeBuildInputs = [
      meson
      ninja
      python
      python3.pkgs.wrapPython
      cmake
      pkg-config
      libxslt
      docbook_xsl
      docbook_xml_dtd_45
      intltool
      doxygen
      wrapGAppsHook3
      autoPatchelfHook
    ];

    buildInputs = [
      abrt
      glib
      libreport
      libadwaita
      python
      asciidoc
      xmlto
      gobject-introspection
    ];

    postFixup = ''
      wrapPythonProgramsIn "$out/bin" "$out ${python}"

      substituteInPlace $out/share/applications/org.freedesktop.GnomeAbrt.desktop \
        --replace-fail "Exec=gnome-abrt" "Exec=$out/bin/gnome-abrt"
    '';

    meta = with lib; {
      description = "ABRT oopses list designed according to https://live.gnome.org/Design/Apps/Oops";
      homepage = "https://github.com/abrt/gnome-abrt";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [];
      mainProgram = "gnome-abrt";
      platforms = platforms.all;
    };
  }
