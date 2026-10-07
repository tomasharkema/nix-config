{
  config,
  lib,
  pkgs,
  ...
}: let
  shellInit = shell:
    "source "
    + cfg.package
    + "/Applications/iTerm2.app/Contents/Resources/iterm2_shell_integration."
    + shell;
  cfg = config.programs.iterm2;
in {
  options.programs.iterm2 = {
    enable = lib.mkEnableOption "Enable the iTerm2 terminal emulator (system-wide).";
    package = lib.mkOption {
      type = lib.types.package;
      default =
        if pkgs.stdenv.hostPlatform.isDarwin
        then pkgs.iterm2
        else
          pkgs.iterm2.overrideAttrs (o: {
            # Remove the generated binary
            installPhase =
              o.installPhase
              + ''
                rm -rf $out/bin
              '';
            meta.platforms = o.meta.platforms ++ lib.platforms.linux;
          });
      description = "The iTerm2 package to use.";
    };
    enableBashIntegration = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.bash.enable;
      description = "Enable iTerm2 bash integration.";
    };
    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.zsh.enable;
      description = "Enable iTerm2 zsh integration.";
    };
    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.fish.enable;
      description = "Enable iTerm2 fish integration.";
    };
  };
  config = lib.mkIf false {
    home.packages = lib.mkIf cfg.enable [cfg.package];
    programs.bash.initExtra = lib.mkIf cfg.enableBashIntegration (shellInit "bash");
    programs.zsh.initExtraFirst = lib.mkIf cfg.enableZshIntegration (shellInit "zsh");
    programs.fish.shellInit = lib.mkIf cfg.enableFishIntegration (shellInit "fish");
  };
}
# {...}: {}

