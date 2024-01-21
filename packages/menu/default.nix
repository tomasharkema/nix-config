{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "menu";
  runtimeInputs = with pkgs; [jq gum nix-eval-jobs nixos-rebuild];
  text = ''
    gum confirm "Wanna run an update?" && \
      gum spin --spinner dot --title "Building..." -- sudo nixos-rebuild switch "github:tomasharkema/nix-config/update"
  '';
}
