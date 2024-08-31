{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.trait.developer;
in {
  options.trait.developer = {enable = mkEnableOption "dev";};
  config = mkIf cfg.enable {
    # system.nixos.tags = ["developer"];

    environment.systemPackages = with pkgs; [
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
