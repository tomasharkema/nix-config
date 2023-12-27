{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "maclaunch";

  src = pkgs.fetchFromGitHub {
    owner = "hazcod";
    repo = "maclaunch";
    rev = "0a4962623dffa84050b5b778edb69f8603fa6c1a";
    hash = "sha256-CA0bT1auUkDdboQeb7FDl2HM2AMoocrU2/hmBbNYK8A=";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv maclaunch.sh $out/bin/maclaunch
    chmod +x $out/bin/maclaunch
  '';
}
