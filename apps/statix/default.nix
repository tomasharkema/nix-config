{ pkgs, ... }:

let
  nix-linter = pkgs.writeShellScriptBin "nix-linter" ''
    ${pkgs.statix}/bin/statix check -c ${./config.toml} $1
  '';
in [ nix-linter pkgs.statix ]
