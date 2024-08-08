# https://github.com/6E006B/usbguard-gnome
{
  python3Packages,
  fetchFromGitHub,
  glib,
  gobject-introspection,
  libappindicator-gtk3,
  gtk3,
  libnotify,
  wrapGAppsHook,
}:
with python3Packages;
  buildPythonApplication rec {
    pname = "usbguard-gnome";
    version = "0.0.1";
    format = "other";

    src = fetchFromGitHub {
      owner = "6E006B";
      repo = "usbguard-gnome";
      rev = "26d300b3597db233cdddbed49dd1cc2c3aecbdb6";
      hash = "sha256-dAJqkWwsuYgQRejzHRF1JnvO8ecogZa0MNdxgijD2qg=";
    };

    propagatedBuildInputs = [
      pygobject3
      pyparsing
      glib
      dbus-python
      gobject-introspection
      pydbus
      libappindicator-gtk3
      gst-python
      gtk3
      libnotify
    ];

    nativeBuildInputs = [
      wrapGAppsHook
      libappindicator-gtk3
      gobject-introspection
      libnotify
    ];

    postBuild = ''
      ${python.pythonOnBuildForHost.interpreter} -O -m compileall src
    '';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/lib
      mkdir -p $out/mo
      mkdir -p $out/share/glib-2.0/schemas
      mkdir -p $out/share/applications

      cp src/org.gnome.usbguard.gschema.xml $out/share/glib-2.0/schemas/org.gnome.usbguard.gschema.xml

      cp "usbguard applet.desktop" $out/share/applications/usbguard-applet.desktop
      cp "usbguard.desktop" $out/share/applications/usbguard.desktop

      cp -r src/. $out/lib/
      cp -r mo/. $out/mo/
      ln -s $out/lib/usbguard_gnome_applet.py $out/bin/usbguard-gnome

      wrapProgram $out/lib/usbguard_gnome_applet.py --set PYTHONPATH $PYTHONPATH
      wrapProgram $out/lib/usbguard_gnome_window.py --set PYTHONPATH $PYTHONPATH
      wrapProgram $out/bin/usbguard-gnome --set PYTHONPATH $PYTHONPATH

      substituteInPlace "$out/share/applications/usbguard-applet.desktop" \
        --replace-fail "python /opt/usbguard-gnome/src" "$out/lib" \
        --replace-fail "Icon=usbguard-icon" "Icon=$out/lib/usbguard-icon"

      substituteInPlace "$out/share/applications/usbguard.desktop" \
        --replace-fail "python /opt/usbguard-gnome/src" "$out/lib" \
        --replace-fail "Icon=usbguard-icon" "Icon=$out/lib/usbguard-icon"
    '';
  }
