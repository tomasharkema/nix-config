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

    package = mkOption {
      # name = "inshellisense package";
      default = pkgs.custom.inshellisense;
      type = with types; package;
    };
  };

  config = let
    scriptRoot = "${cfg.package}/lib/node_modules/@microsoft/inshellisense/shell";
    rcFile = "${scriptRoot}/shellIntegration-rc.zsh";
  in
    mkIf cfg.enable {
      home.packages = [cfg.package];

      programs.zsh = {
        initExtra = ''
          if [[ -f "${rcFile}" ]]; then
            . "${rcFile}"
          else
            echo "inshellisense rc file not found..."
          fi
        '';
        profileExtra = ''
          . "${cfg.package}/lib/node_modules/@microsoft/inshellisense/shell/shellIntegration-profile.zsh"
        '';
        loginExtra = ''
          . "${cfg.package}/lib/node_modules/@microsoft/inshellisense/shell/shellIntegration-login.zsh"
        '';
        envExtra = ''
          . "${cfg.package}/lib/node_modules/@microsoft/inshellisense/shell/shellIntegration-env.zsh"
        '';
      };
    };
}
