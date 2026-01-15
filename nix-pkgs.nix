{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      # keep-sorted start
      alejandra
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
      fldigi
      fup-repl
      gcc
      gcc-arm-embedded
      ggh
      manix
      minimodem
      mqttui
      nerd-font-patcher
      nil
      nix-bisect
      nix-bundle
      nix-doc
      nix-init
      # nix-eval-jobs
      nix-inspect
      nix-janitor
      nix-output-monitor
      nix-pin
      nix-prefetch-git
      nix-prefetch-scripts
      nix-query-tree-viewer
      nix-search-tv
      nix-sweep
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
      wol
      xxd
      # keep-sorted end
    ];
  };
}
