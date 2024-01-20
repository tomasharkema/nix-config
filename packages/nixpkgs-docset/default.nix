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
    sha256 = "sha256:1c5nv9jxy7jnvyzjwzp74qli6asl7biyd2znlzxcbnqdfxfnmq89";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ./store/*.docset/. $out/nixpkgs.docset
  '';
}
