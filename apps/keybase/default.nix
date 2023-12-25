{
  lib,
  pkgs,
  ...
}: {
  services.kbfs = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
  };
}
