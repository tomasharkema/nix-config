{
  config,
  pkgs,
  ...
}: {
  age.secrets.atuin = {
    file = ../../secrets/atuin.age;
    path = "/tmp/atuin.key";
  };

  home.packages = with pkgs; [atuin];
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      sync_frequency = "15m";
      key_path = config.age.secrets.atuin.path;
      # session_path = config.age.secrets.atuin_session.path;
      enter_accept = false;
      # workspaces = true;
    };
  };
}
