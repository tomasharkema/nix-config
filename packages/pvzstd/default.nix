{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "pvzstd";
  runtimeInputs = with pkgs; [gum pv zstd gnutar];
  text = ''
    exec pv - -N in -B 500M -pterbT | zstd -e - -19 -T8 | pv -N out -B 500M -pterbT
  '';
}
