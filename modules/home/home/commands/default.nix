{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  config = {
    programs.commands = {
      enable = osConfig.gui.gnome.enable;
      commands = [
        {
          "title" = "Update";
          "command" = "${pkgs.gnome-terminal}/binn/gnome-terminal -- menu"; # "${lib.getExe pkgs.xdg-terminal-exec} menu";
          "icon" = "utilities-terminal";
        }
        {
          "title" = "Termimal";
          "command" = "gnome-terminal";
          "icon" = "utilities-terminal";
        }
        {
          "title" = "File Manager 3";
          "command" = "nautilus";
          "icon" = "folder";
        }
        {"type" = "separator";}
        {
          "title" = "Web Browser";
          "command" = "firefox";
          "icon" = "web-browser";
        }
        {"type" = "separator";}
        {
          "title" = "SSH Connections";
          "type" = "submenu";
          "submenu" = [
            {
              "title" = "Connect to Server (SSH)";
              "command" = "gnome-terminal -- bash -c 'ssh root@10.144.1.2 -p 8022'";
              "icon" = "utilities-terminal";
            }
          ];
        }
      ];
    };
  };
}
