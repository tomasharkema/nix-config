{
  config,
  pkgs,
  lib,
  ...
}: let
  update = pkgs.writeShellScriptBin "update" ''

    set -e

    nix flake update --refresh &
    PS1=$!

    devenv update &
    PS2=$!

    wait $PS1 $PS2

  '';
in {
  config = {
    home.packages = [update];
  };
}
