{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "run-checks";
  runtimeInputs = with pkgs; [statix nixpkgs-lint deadnix];

  text = ''
    set -x
    set -e

    statix check
    deadnix -l -L .
  '';
}
