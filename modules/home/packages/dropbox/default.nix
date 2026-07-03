{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isLinux && pkgs.stdenvNoCC.hostPlatform.isx86_64) {
    # services.dropbox = {enable = true;};
  };
}
