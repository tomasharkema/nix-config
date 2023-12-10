{ config, ... }: {
  age.secrets.atuin = {
    file = ../../secrets/atuin.age;
    path = "/tmp/atuin.key";
  };

  age.secrets.atuin_session = {
    file = ../../secrets/atuin_session.age;
    path = "/tmp/atuin_session.key";
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      sync_frequency = "15m";
      key_path = config.age.secrets.atuin.path;
      session_path = config.age.secrets.atuin_session.path;
      enter_accept = false;
      workspaces = true;
    };
  };
}

