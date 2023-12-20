{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [ atuin ];
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      sync_frequency = "15m";
      sync_address = "https://atuin.harke.ma";
      enter_accept = false;
      workspaces = true;
    };
  };
}
