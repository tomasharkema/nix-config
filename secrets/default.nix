{ ... }: {
  age.secrets.atuin = {
    file = ./atuin.age;
    mode = "777";
    owner = "tomas";
    group = "tomas";
  };
  age.secrets.tailscale = {
    file = ./tailscale.age;
    # mode = "770";
    owner = "tomas";
    group = "tomas";
  };
  age.secrets.gh = {
    file = ./gh.age;
    # mode = "770";
    owner = "tomas";
    group = "tomas";
  };
}
