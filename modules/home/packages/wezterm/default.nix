{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      package = pkgs.wezterm;

      extraConfig = builtins.readFile (pkgs.substituteAll {
        src = ./wezterm.lua;

        env = {
          # weztermStatus = let
          #   pkg = pkgs.fetchgit {
          #     url = "https://github.com/yriveiro/wezterm-status.git";
          #     rev = "665cc2f33a97a20c61288706bedf3b2fc95c2399";
          #     hash = "sha256-Fww+MDT006NWr8hlYzLCBlj72LNbAxaCHj8rfonXar4=";
          #     leaveDotGit = true;
          #   };
          # in "file://${pkg}";
          # wezPerProjectWorkspace = let
          #   pkg = pkgs.fetchgit {
          #     url = "https://github.com/sei40kr/wez-per-project-workspace.git";
          #     rev = "1fa76b0cd8025c0d445895cb835bedddff077657";
          #     hash = "sha256-WXnCdo7WSZIW5gZoTkHGEwKvhBq2roMcojm6nXeiY60=";
          #     leaveDotGit = true;
          #   };
          # in "file://${pkg}";
          weztermStatus = "https://github.com/yriveiro/wezterm-status";
        };
      });
    };
  };
}
