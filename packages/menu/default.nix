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
      sudo nixos-rebuild switch \'github:tomasharkema/nix-config/update\'
  '';
}
