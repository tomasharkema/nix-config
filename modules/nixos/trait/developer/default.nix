{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.trait.developer;
in {
  options.trait.developer = {enable = lib.mkEnableOption "dev";};
  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["developer"];

    environment.systemPackages = with pkgs;
    # nix
      [
        # # snowfallorg.flake
        # cachix
        nix-init
        # nixci
        # agenix
        deadnix
        deploy-rs
        devenv

        flake-checker
        hydra-check
        hydra-cli
        autoflake
        # fh
        hydra-cli
        manix
        nix-search-cli

        nil
        nixd
        nix-eval-jobs
        # nix-fast-build
        nix-output-monitor
        nix-prefetch-git
        nix-prefetch-scripts
        # nix-serve
        nix-tree
        nixfmt-rfc-style

        nixos-shell
        nixpkgs-lint
        nurl
        statix
      ]
      ++ [go go-outline gopls godef golint gopkgs gopls gotools]
      ++ (lib.optional pkgs.stdenv.isLinux nix-du);
  };
}
