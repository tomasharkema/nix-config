_: {
  age.secrets.attic-key = {
    file = ./attic-key.age;
    mode = "770";
  };
  # age.secrets.atuin-key = {
  #   file = ./atuin-key.age;
  #   # mode = "770";
  #   path = "/tmp/atuin/key";
  #   owner = "tomas";
  #   group = "tomas";
  # };
  # age.secrets.atuin-session = {
  #   file = ./atuin-session.age;
  #   # mode = "770";
  #   path = "/tmp/atuin/session";
  #   owner = "tomas";
  #   group = "tomas";
  # };
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
