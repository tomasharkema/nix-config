{
  stdenv,
  git,
  pkgs,
  zlib,
  openssl,
}:
stdenv.mkDerivation rec {
  name = "atophttpd";
  version = "2.8.0";

  src = pkgs.fetchgit {
    url = "https://github.com/pizhenwei/atophttpd.git";
    rev = "v${version}";
    sha256 = "sha256-/j04D7dRdRyAN36iISo+ndQERex5BtqbadVFDO4OH48=";
    fetchSubmodules = true;
  };

  makeFlags = ["DESTDIR=$(out)" "PREFIX=$(out)"];

  buildPhase = "make bin";

  postInstall = ''
    mkdir $out/bin
    mkdir $out/share
    cp $out/usr/bin/atophttpd $out/bin/atophttpd
    cp -r $out/usr/share/man $out/share
    rm -rf $out/usr
  '';

  buildInputs = [git zlib openssl];
}
