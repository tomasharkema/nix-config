{
  pkgs,
  lib,
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "zeal-docset";
  version = "2024-01-19";
  src = builtins.fetchTarball {
    url = "https://nixosbrasil.github.io/nix-docgen/nixpkgs-unstable/nixpkgs.docset.tgz";
    sha256 = "sha256:0z6iahfihj90k5y0ra2zivfq2p8qgnnifbs09y0v11x5hwjjyhy6";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ./store/*.docset/. $out/nixpkgs.docset
  '';
}
