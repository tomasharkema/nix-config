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
    sha256 = "sha256:100hcqmwsj48pspj19jzbaa0bxjddcwvki8w6fvg875prp21xgdn";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./store/*.docset/. $out/nixpkgs.docset

    runHook postInstall
  '';
}
