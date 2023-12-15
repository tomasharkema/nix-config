{pkgs, ...}: let
  nix-linter = pkgs.writeShellScriptBin "nix-linter" ''
    ${pkgs.statix}/bin/statix check -c ${./config.toml} $1
  '';
  nix-linter-fix = pkgs.writeShellScriptBin "nix-linter-fix" ''
    ${pkgs.statix}/bin/statix fix -c ${./config.toml} $1
  '';
  nixpkgs-fmt = pkgs.writeShellScriptBin "nixpkgs-fmt" ''
    nix fmt $@
  '';
in [nix-linter nix-linter-fix pkgs.statix nixpkgs-fmt]
