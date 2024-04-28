{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf pkgs.stdenv.isLinux {
    services.dropbox = {
      enable = true;
    };
  };
}
