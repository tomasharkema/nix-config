{
  fetchFromGitHub,
  bluez,
  python312Packages,
  libcap,
  glib,
  gobject-introspection,
  wrapGAppsHook,
}:
with python312Packages; let
  prctl = buildPythonPackage rec {
    pname = "python-prctl";
    version = "1.8.1";
    format = "setuptools";

    buildInputs = [libcap];

    doCheck = false;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-tMqaJafU8azk//0fOi5k71II/gX5KfPt1eJwgcp+Z84=";
    };
  };
in
  #https://github.com/jrouleau/bluetooth-autoconnect
  buildPythonApplication rec {
    pname = "bluetooth-autoconnect";
    version = "0.0.1";
    format = "other";
    doCheck = false;

    src = fetchFromGitHub {
      owner = "jrouleau";
      repo = "bluetooth-autoconnect";
      rev = "9b6285367e1852290d2fe68a5001c";
      hash = "sha256-qfU7fNPNRQxIxxfKZkGAM6Wd3NMuNI+8DqeUW+LYRUw=";
    };

    propagatedBuildInputs = [
      glib
      dbus-python
      gobject-introspection
      pygobject3
      prctl
      bluez
    ];

    nativeBuildInputs = [glib gobject-introspection dbus-python pygobject3 wrapGAppsHook];

    installPhase = ''
      install -Dm755 $src/bluetooth-autoconnect $out/bin/bluetooth-autoconnect
      install -Dm644 $src/bluetooth-autoconnect.service $out/etc/systemd/system/bluetooth-autoconnect.service

      substituteInPlace "$out/etc/systemd/system/bluetooth-autoconnect.service" \
        --replace-fail "/usr/bin" "$out/bin"
    '';
  }
