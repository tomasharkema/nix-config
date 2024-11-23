{stdenv}:
stdenv.mkDerivation {
  pname = "nix-helpers";
  version = "0.0.1";
  dontUnpack = true;
  installPhase = ''
    install -Dm 770 ${./trace-which.sh} $out/bin/trace-which
    install -Dm 770 ${./trace-symlink.sh} $out/bin/trace-symlink
  '';
}
