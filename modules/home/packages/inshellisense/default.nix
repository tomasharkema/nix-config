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
    enable = mkEnableOption "inshellisense" // {default = true;};
    enableZshIntegration = mkEnableOption "inshellisense zsh integration" // {default = true;};

    package = mkOption {
      default = pkgs.custom.inshellisense;
      type = with types; package;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = [cfg.package];

    assertions = builtins.map (n: {
      message = "${n} doesnt exist";
      assertion = builtins.pathExists n;
    }) ["${cfg.package}/share/shell/shellIntegration-rc.zsh" "${cfg.package}/share/shell/shellIntegration-profile.zsh"];

    programs.zsh = mkIf cfg.enableZshIntegration {
      initExtra = ''
        . "${cfg.package}/share/shell/shellIntegration-rc.zsh"
      '';
      profileExtra = ''
        . "${cfg.package}/share/shell/shellIntegration-profile.zsh"
      '';
      loginExtra = ''
        . "${cfg.package}/share/shell/shellIntegration-login.zsh"
      '';
      envExtra = ''
        . "${cfg.package}/share/shell/shellIntegration-env.zsh"
      '';

      # initExtra = ''
      #   # ---------------- inshellisense shell plugin ----------------
      #   if [[ -z "$ISTERM" && $- = *i* && $- != *c* ]]; then
      #     if [[ -o login ]]; then
      #       is -s zsh --login ; exit
      #     else
      #       is -s zsh ; exit
      #     fi
      #   fi
      # '';
    };
  };
}
