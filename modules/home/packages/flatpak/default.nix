{ config, osConfig, lib, ... }:
with lib; {
  config = mkIf osConfig.apps.flatpak.enable {
    home = {
      # file.".local/share/flatpak/overrides/global".text = ''
      #   [Context]
      #   filesystems=/home/tomas/.local/share/fonts:ro;/home/tomas/.icons:ro;/nix/store:ro
      # '';
      # activation = {
      #   fontSymlink = ''
      #     ln -sfn /run/current-system/sw/share/X11/fonts /home/tomas/.local/share/fonts
      #   '';
      # };
    };
  };
}
