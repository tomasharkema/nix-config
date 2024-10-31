{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) {
    # services.dropbox = {enable = true;};
  };
}
