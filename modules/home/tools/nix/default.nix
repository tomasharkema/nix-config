{
  pkgs,
  inputs,
  ...
}:
with pkgs; {
  config = {
    home.packages = with pkgs; [
      inputs.fh.packages.${system}.default

      agenix # .packages.${system}.default
      alejandra # .defaultPackage.${system}
      deadnix
      manix
      nil #.packages.${system}.default
      nix

      #  nix-cache-watcher

      nix-init
      nix-output-monitor
      nix-prefetch-scripts
      nix-serve
      nix-tree
      nixci
      nixd
      nixos-shell
      nixpkgs-fmt
      nixpkgs-lint
      nurl
      statix
    ];
  };
}
