{
  config,
  lib,
  pkgs,
  ...
}: let
  intelli_home =
    if pkgs.stdenv.isLinux
    then "$HOME/.local/share/intelli-shell"
    else "$HOME/Library/Application Support/org.IntelliShell.Intelli-Shell";
in {
  config = {
    home.packages = [pkgs.custom.intelli-shell];

    programs.zsh.initExtra = ''
      export INTELLI_HOME="${intelli_home}"
      if [ ! -d "$INTELLI_HOME" ]; then
        mkdir -p "$INTELLI_HOME"
      fi
      ln -sfn "${pkgs.custom.intelli-shell}/bin" "$INTELLI_HOME/bin"
      source "$INTELLI_HOME/bin/intelli-shell.sh"
    '';
  };
}
