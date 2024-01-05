

{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "run-checks";
  runtimeInputs = with pkgs; [statix nixpkgs-lint];
  

  text = ''
    set -x
    set -e

    statix check

  '';
}
