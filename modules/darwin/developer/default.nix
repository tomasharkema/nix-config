{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.traits.developer;
in {
  options.traits.developer = {enable = lib.mkEnableOption "dev";};
  config = lib.mkIf cfg.enable {
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
