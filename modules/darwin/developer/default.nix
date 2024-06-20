{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.traits.developer;
in {
  options.traits.developer = {enable = mkEnableOption "dev";};
  config = mkIf cfg.enable {
    # system.nixos.tags = ["developer"];

    environment.systemPackages = with pkgs; [
      go
      go-outline
      gopls
      godef
      golint
      gopkgs
      gopls
      gotools
      golangci-lint
    ];
  };
}
