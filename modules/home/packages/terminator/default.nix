{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    programs.terminator = {
      enable = true;
    };
  };
}
