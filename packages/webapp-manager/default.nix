# https://github.com/linuxmint/webapp-manager
{
  fetchFromGitHub,
  stdenv,
  gettext,
}:
stdenv.mkDerivation rec {
  pname = "webapp-manager";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "webapp-manager";
    rev = "${version}";
    hash = "sha256-bDFILR3sTg/4ITUoia7s+7ilhGgJSiyDdrdmOr6XTrI=";
  };

  buildInputs = [
    gettext
  ];

  installPhase = ''
    mkdir $out
    cp -r ./etc $out
    cp -r ./usr $out

    ln -s $out/usr/bin $out/bin

    ls -la $out
  '';
}
