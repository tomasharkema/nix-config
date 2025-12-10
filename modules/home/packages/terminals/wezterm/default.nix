{
  pkgs,
  lib,
  config,
  ...
}: let
  weztermStatus = pkgs.fetchFromGitHub {
    owner = "yriveiro";
    repo = "wezterm-status";
    rev = "main";
    sha256 = "sha256-9rpuefkcBDgmExIbintzwfMEhKhQDhjQN8fafZLITQ0=";
    leaveDotGit = true;
  };
in {
  config = {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      package = pkgs.wezterm;
    };

    xdg.configFile = {
      "wezterm/wezterm.lua".source = pkgs.replaceVars ./wezterm.lua {
        wezPerProjectWorkspace = "https://github.com/sei40kr/wez-per-project-workspace";
        weztermStatus = "https://github.com/yriveiro/wezterm-status";
      };
    };
  };
}
