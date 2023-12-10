{ config, ... }: {
  # age.secrets.atuin.file = ../../secrets/atuin.age;
  age.secrets.atuin = {
    file = ../../secrets/atuin.age;
    path = "/tmp/atuin.age";
    # mode = "777";
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      sync_frequency = "15m";
      key_path = config.age.secrets.atuin.path;
    };
  };
}

