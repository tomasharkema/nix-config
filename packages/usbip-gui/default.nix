{ python3, fetchFromGitHub, stdenv, makeWrapper, }:
stdenv.mkDerivation {

  pname = "usbip-gui";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "K-Francis-H";
    repo = "usbip-gui";
    rev = "23c7a5916b4cf8aea822b6af8f85d6fb98bcc186";
    hash = "sha256-h2wXCDdhuEXejqHFjGi3J3Rfx1EyB/fnzACebDQu2Yo=";
  };

  dontBuild = true;

  propagatedBuildInputs = [
    (python3.withPackages
      (pythonPackages: with pythonPackages; [ tkinter uritools ]))
  ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    echo "#!/usr/bin/env python3" > /tmp/gui.py
    cat gui.py >> /tmp/gui.py

    mkdir -p $out/bin
    install -Dm755 /tmp/gui.py $out/bin/usbip-gui
    wrapProgram $out/bin/usbip-gui
  '';
}
