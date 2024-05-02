{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.inshellisense;
in {
  options.programs.inshellisense = {
    enable = mkEnableOption "inshellisense";
    enableZshIntegration = mkEnableOption "inshellisense zsh integration";

    package = mkOption {
      default = pkgs.custom.inshellisense;
      type = with types; package;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = [cfg.package];

    programs.zsh = mkIf cfg.enableZshIntegration {
      # initExtra = ''
      #   . "${cfg.package}/share/shellIntegration-rc.zsh"
      # '';
      # profileExtra = ''
      #   . "${cfg.package}/share/shellIntegration-profile.zsh"
      # '';
      # loginExtra = ''
      #   . "${cfg.package}/share/shellIntegration-login.zsh"
      # '';
      # envExtra = ''
      #   . "${cfg.package}/share/shellIntegration-env.zsh"
      # '';

      initExtra = ''
        # ---------------- inshellisense shell plugin ----------------
        if [[ -z "$ISTERM" && $- = *i* && $- != *c* ]]; then
          if [[ -o login ]]; then
            is -s zsh --login ; exit
          else
            is -s zsh ; exit
          fi
        fi
      '';
    };
  };
}
