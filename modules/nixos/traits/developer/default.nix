{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.traits.developer;
in {
  options.traits.developer = {
    enable = mkEnableOption "dev";
  };
  config = mkIf cfg.enable {
    system.nixos.tags = ["developer"];
    environment.systemPackages = with pkgs; [
      devenv
      deploy-rs
      nixfmt
      nix-prefetch-git
      nix-output-monitor
      flake-checker
      flake-checker
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
