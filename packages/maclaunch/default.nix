{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation rec {
  name = "maclaunch";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "hazcod";
    repo = name;
    rev = "${version}";
    hash = "sha256-CA0bT1auUkDdboQeb7FDl2HM2AMoocrU2/hmBbNYK8A=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp maclaunch.sh $out/bin/maclaunch
    chmod +x $out/bin/maclaunch

    runHook postInstall
  '';
}
