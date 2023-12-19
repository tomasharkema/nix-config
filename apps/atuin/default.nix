{ config
, pkgs
, ...
}: {
  age.secrets.atuin-key = {
    file = ../../secrets/atuin-key.age;
    path = "/tmp/atuin.key";
    # owner = "tomas";
    # group = "tomas";
  };
  age.secrets.atuin-session = {
    file = ../../secrets/atuin-session.age;
    path = "/tmp/atuin.session";
    # owner = "tomas";
    # group = "tomas";
  };

  home.packages = with pkgs; [ atuin ];
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      sync_frequency = "15m";
      sync_address = "https://atuin.harke.ma";
      key_path = config.age.secrets.atuin-key.path;
      session_path = config.age.secrets.atuin-session.path;
      enter_accept = false;
      workspaces = true;
    };
  };
}
