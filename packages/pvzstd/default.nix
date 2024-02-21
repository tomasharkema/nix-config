{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "pvzstd";
  runtimeInputs = with pkgs; [gum pv zstd gnutar];
  text = ''
    pv -cN in -B 500M -pterbTC | zstd -e - -19 -T8 | pv -cN out -B 500M -pterbTC
  '';
}
