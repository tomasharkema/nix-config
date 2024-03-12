{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "menu";

  runtimeInputs = with pkgs;
    [
      gum
      nixos-rebuild
      nix-output-monitor
      zsh
      fast-ssh
      dialog
      manix
      nix-search-cli
    ]
    ++ (lib.optional pkgs.stdenv.isLinux nix-du);

  text = builtins.readFile ./menu.sh;
}
