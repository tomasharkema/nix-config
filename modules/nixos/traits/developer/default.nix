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

    environment.systemPackages = with pkgs;
    # nix
      [
        # # snowfallorg.flake
        # cachix
        # nix-init
        # nixci
        agenix
        alejandra
        deadnix
        deploy-rs
        devenv
        fh
        # flake-checker
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
        nixfmt
        nixos-shell
        nixpkgs-fmt
        nixpkgs-lint
        nurl
        statix
      ]
      # go
      ++ [
        go
        go-outline
        gopls
        godef
        golint
        gopkgs
        gopls
        gotools
      ]
      ++ (lib.optional pkgs.stdenv.isLinux nix-du);
  };
}
