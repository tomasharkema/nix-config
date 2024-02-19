{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "menu";

  runtimeInputs = with pkgs; [gum nixos-rebuild nix-output-monitor zsh fast-ssh dialog];

  text = builtins.readFile ./menu.sh;
}
