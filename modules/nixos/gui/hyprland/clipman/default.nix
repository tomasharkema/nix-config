# Clipman allows you to save and retrieve clipboard history.
{
  pkgs,
  config,
  ...
}: let
  clipboard-clear = pkgs.writeShellScriptBin "clipboard-clear" ''
    clipman clear --all
  '';

  clipboard = pkgs.writeShellScriptBin "clipboard" ''
    clipman pick --tool=wofi
  '';
in {
  home-manager.users."${config.user.name}" = {
    wayland.windowManager.hyprland.settings.exec-once = ["${clipboard-clear}" "wl-paste -t text --watch clipman store"];
    home.packages = with pkgs; [clipman clipboard clipboard-clear];
    services.clipman.enable = true;
  };
}
