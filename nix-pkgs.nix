{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    environment.systemPackages =
      (lib.optionals pkgs.stdenv.isx86_64 (with pkgs; [
        nix-doc
        wol
        minimodem
      ]))
      ++ (with pkgs; [
        # keep-sorted start
        alejandra
        atuin-desktop
        autoflake
        bc
        cachix
        calc
        caligula
        deadnix
        deploy-rs
        devenv
        disnix
        flake-checker
        fup-repl
        gcc
        gcc-arm-embedded
        ggh
        manix
        # godap
        #fldigi
        mqttui
        nerd-font-patcher
        nil
        nix-bisect
        nix-bundle
        nix-init
        # nix-eval-jobs
        nix-inspect
        nix-output-monitor
        nix-pin
        nix-prefetch-git
        nix-prefetch-scripts
        nix-query-tree-viewer
        nix-search-tv
        # nix-simple-deploy
        nix-tree
        nix-update
        nix-update-source
        nix-visualize
        nixd
        nixfmt
        nixos-option
        nixos-shell
        nixpkgs-fmt
        nixpkgs-lint
        nox
        nurl
        picotool
        platformio-core
        python3Packages.uv
        rustup
        statix
        tio
        xxd
        # keep-sorted end
      ]);
  };
}
