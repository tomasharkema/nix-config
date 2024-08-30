{ pkgs, lib, ... }:
with pkgs;
with lib; {
  config = mkIf false { home.packages = [ ]; };
}
