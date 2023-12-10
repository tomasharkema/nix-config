{ config, ... }: {
  # age.secrets.atuin.file = ../../secrets/atuin.age;

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = { key_path = config.age.secrets.atuin.path; };
  };

  # sops.secrets.atuin_key = { sopsFile = ../secrets.yaml; };
}

