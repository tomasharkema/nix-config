{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    environment.systemPackages =
      (lib.optionals pkgs.stdenv.isx86_64 [
        # nix-doc
      ])
      ++ (with pkgs; [
        wol
        nix-init
        disnix
        nox
        alejandra
        autoflake
        attic-client
        cachix
        deadnix
        deploy-rs
        devenv
        flake-checker
        fup-repl
        manix
        nerd-font-patcher
        nil
        nix-bisect
        nix-bundle
        # nix-eval-jobs
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
      ]);
  };
}
