{
  pkgs,
  lib,
  ...
}:
with pkgs; let
  darwin-build =
    #lib.mkIf pkgs.stdenv.isDarwin
    writeShellScriptBin "darwin-build" ''
      darwin-rebuild switch --flake ~/Developer/nix-config
    '';
in {
  config = {
    environment.systemPackages = [
      darwin-build
    ];
  };
}
