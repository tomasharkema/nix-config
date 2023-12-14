{ pkgs, ... }:

let
  darwin-build = pkgs.writeShellScriptBin "darwin-build" ''
    exec darwin-rebuild switch --flake ~/Developer/nix-config
  '';

in { environment.systemPackages = [ darwin-build ]; }
