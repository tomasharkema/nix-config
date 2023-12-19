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
  };
  age.secrets.tailscale = {
    file = ./tailscale.age;
    mode = "770";
  };
  age.secrets.gh = {
    file = ./gh.age;
    mode = "770";
  };
  age.secrets."resilio-p" = {
    file = ./resilio-p.age;
    mode = "770";
  };
  age.secrets."resilio-docs" = {
    file = ./resilio-docs.age;
    mode = "770";
  };
  age.secrets."resilio-shared-public" = {
    file = ./resilio-shared-public.age;
    mode = "770";
  };
  age.secrets.netdata = {
    file = ./netdata.age;
    mode = "770";
  };
}
