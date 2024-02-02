{
  pkgs,
  lib,
  ...
}:
with pkgs;
with lib; {
  config = mkIf false {
    home.packages = [
      go
      go-outline
      gocode
      gocode-gomod
      godef
      golint
      gopkgs
      gopls
      gotools
    ];
  };
}
