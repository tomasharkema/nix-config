{ pkgs, config, lib, ... }:
with lib; {
  config = mkIf (pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64 && false) {
    services.dropbox = { enable = true; };
  };
}
