_: {
  # age.secrets.atuin = {
  #   file = ./atuin.age;
  #   # mode = "777";
  #   owner = "tomas";
  #   group = "tomas";
  #   path = "/tmp/atuin.key";
  # };
  age.secrets.attic-key = {
    file = ./attic-key.age;
    mode = "770";
    # owner = "tomas";
    # group = "tomas";
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
  age.secrets."resilio-p" = {
    file = ./resilio-p.age;
    # mode = "770";
    owner = "rslsync";
    group = "rslsync";
  };
  age.secrets."resilio-docs" = {
    file = ./resilio-docs.age;
    # mode = "770";
    owner = "rslsync";
    group = "rslsync";
  };
  age.secrets."resilio-shared-public" = {
    file = ./resilio-shared-public.age;
    owner = "rslsync";
    group = "rslsync";
  };
  age.secrets.netdata = { file = ./netdata.age; };
}
