{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.commands;

  jsonFormat = pkgs.formats.json {};
in {
  options.programs.commands = {
    enable = mkEnableOption "commands";

    commands = mkOption {
      type = jsonFormat.type;
      default = [];
      description = "commands";
    };
  };

  config = mkIf cfg.enable {
    dconf = {
      settings = {
        "org/gnome/shell" = {
          enabled-extensions = ["command-menu@arunk140.com"];
        };
      };
    };
    home = {
      # packages = with pkgs; [
      #   gnomeExtensions.command-menu
      # ];

      file = {".commands.json".text = "${builtins.toJSON cfg.commands}";};
    };
  };
}
