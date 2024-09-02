{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  config = {
    environment.systemPackages = with pkgs;
      (optionals pkgs.stdenv.isx86_64 [
        # nix-doc
      ])
      ++ [
        #   # # snowfallorg.flake
        #   # nix-init
        #   # nixci
        #   # nixos-shell
        #   # nixpkgs-fmt
        #   # nixpkgs-lint
        #   hosts = inputs.self.nixosConfigurations;
        #   nix-prefetch-scripts
        #   nix-serve
        # (nixos-hosts.override {
        # })
        # # snowfallorg.flake
        # attic
        # cachix
        # custom.nixos-revision
        # nix-delegate
        # nix-delegate
        # nix-fast-build
        # nix-fast-build
        # nix-init
        # nix-janitor
        # nix-janitor
        # nix-plugins
        # nix-plugins
        # nix-serve
        # nixci

        nux
        disnix
        nox

        # agenix
        alejandra
        autoflake
        attic-client
        cachix
        deadnix
        deploy-rs

        # devenv

        # fh
        flake-checker
        # fup-repl
        hydra-check
        hydra-cli
        manix
        nerd-font-patcher
        nil
        nix-bisect
        nix-bundle
        nix-eval-jobs
        nix-inspect
        nix-output-monitor
        nix-pin
        nix-prefetch-git
        nix-prefetch-scripts
        nix-query-tree-viewer
        # nix-simple-deploy
        nix-tree
        nix-update
        nix-update-source
        nix-visualize

        nixd
        nixfmt-rfc-style
        nixos-option
        nixos-shell
        nixpkgs-fmt
        nixpkgs-lint
        nurl
        statix
      ];
  };
}
