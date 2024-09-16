{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    programs.terminator = lib.mkIf pkgs.stdenvNoCC.isLinux {
      enable = true;
    };
  };
}
