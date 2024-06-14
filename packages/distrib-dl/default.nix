# https://github.com/nodiscc/distrib-dl/blob/master/distrib-dl

{ pkgs, fetchFromGitHub, stdenvNoCC, }:
stdenvNoCC.mkDerivation rec {
  pname = "distrib-dl";
  version = "1.14.24";
  # let
  src = fetchFromGitHub {
    owner = "nodiscc";
    repo = "distrib-dl";
    rev = version;
    sha256 = "sha256-M6GHUhArLfYgkoQZWpzzte1muR+xLgtptaW0pUI6DWw=";
  };

  installPhase = ''
    install -Dm 755 distrib-dl $out/bin/distrib-dl

    patchShebangs $out/bin/distrib-dl
  '';
}
# pkgs.writeShellScriptBin "distrib-dl" (builtins.readFile "${src}/distrib-dl")
