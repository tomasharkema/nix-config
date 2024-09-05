{
  pkgs,
  lib,
  config,
  ...
}: {
  options.editor = {
    enable = lib.mkEnableOption "editor";

    modifications = lib.mkOption {
      default = [];
      type = lib.types.listOf (lib.types.submodule {
        options = {
          modifications = lib.mkOption {type = lib.types.lines;};
          path = lib.mkOption {type = lib.types.path;};
          type = lib.mkOption {type = lib.types.str;};
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
