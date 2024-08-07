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
    version = "0.0.3";

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

    preBuild = let
      setup = pkgs.writeText "setup.py" ''
        # setup.py
        from distutils.core import setup

        setup(
            name='${pname}',
            version='${version}',
            entry_points={
               'console_scripts': [
                  'usbguard-gnome=usbguard_gnome_applet:main',
                  'usbguard-gnome-window=usbguard_gnome_window:main',
               ],
            },

        )
      '';
    in ''
      cp ${setup} ./setup.py
    '';

    postBuild = ''
      ${python.pythonOnBuildForHost.interpreter} -O -m compileall src
    '';

    postInstall = ''
      install -Dm 644 src/org.gnome.usbguard.gschema.xml $out/share/glib-2.0/schemas/org.gnome.usbguard.gschema.xml

      install -Dm 644 "usbguard applet.desktop" $out/share/applications/org.gnome.usbguard.desktop
      install -Dm 644 "usbguard.desktop" $out/share/applications/org.gnome.usbguard.window.desktop

      install -Dm 644 src/usbguard-icon.svg $out/share/icons/hicolor/scalable/apps/usbguard-icon.svg

      cp -r mo/. $out/mo/

      substituteInPlace "$out/share/applications/org.gnome.usbguard.desktop" \
        --replace-fail "python /opt/usbguard-gnome/src/usbguard_gnome_applet.py" "$out/bin/usbguard-gnome" \
        --replace-fail "Version=1.0" "Version=${version}"

      substituteInPlace "$out/share/applications/org.gnome.usbguard.window.desktop" \
        --replace-fail "python /opt/usbguard-gnome/src/usbguard_gnome_window.py" "$out/bin/usbguard-gnome-window" \
        --replace-fail "Version=1.0" "Version=${version}"

    '';
  }
