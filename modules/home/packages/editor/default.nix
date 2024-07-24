{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.editor = {
    enable = mkEnableOption "editor";

    modifications = mkOption {
      default = [];
      type = types.listOf (types.submodule {
        options = {
          modifications = mkOption {type = types.lines;};
          path = mkOption {type = types.path;};
          type = mkOption {type = types.str;};
        };
      });
    };
  };

  config =
    # let
    #   editorFile = pkgs.writeShellScript "config-editor.sh" ''
    #     ${concatStrings (map (opt: ''
    #         path: ${opt.path}
    #         type: ${opt.type}
    #         modifications: ${opt.modifications}
    #       '')
    #       config.editor.modifications)}
    #   '';
    # in
    {
      # home.activation = {
      #   # editor = ''
      #   #   ${editorFile}
      #   # '';
      #   editor = ''
      #     ${concatStrings (map (opt: let
      #         mods = pkgs.writeText "mods.txt" opt.modifications;
      #       in ''
      #         # ===
      #         # path: ${opt.path}
      #         # type: ${opt.type}
      #         # modifications: ${mods}

      #         ${getExe pkgs.initool} get ${opt.path} ${mods}

      #         # ${opt.modifications}
      #         # ===
      #       '')
      #       config.editor.modifications)}
      #   '';
      # };
    };
}
