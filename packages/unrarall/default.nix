{
  stdenv,
  fetchFromGitHub,
  cksfv,
  unrar,
}:
stdenv.mkDerivation {
  pname = "unrarall";
  version = "1";

  src = fetchFromGitHub {
    owner = "arfoll";
    repo = "unrarall";
    rev = "master";
    sha256 = "sha256-4vmlQbOMUjJvRQRhbW0G/ew6lgWVvOidYLiY+3EaPBg=";
  };

  buildInputs = [cksfv unrar];

  installPhase = ''
    mkdir -p $out/bin
    cp unrarall $out/bin/unrarall
    chmod u+x $out/bin/unrarall
    patchShebangs $out/bin/unrarall
  '';
}
