{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      go
      go-outline
      gdlv
      delve
      godef
      golint
      gopkgs
      gopls
      gotools
      golangci-lint
    ];
  };
}
