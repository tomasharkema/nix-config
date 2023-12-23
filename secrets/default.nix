_: {
  age.secrets.attic-key = {
    file = ./attic-key.age;
    mode = "0664";
  };
  age.secrets.hishtory = {
    file = ./hishtory.age;
    owner = "tomas";
    group = "tomas";
  };
  age.secrets.tailscale = {
    file = ./tailscale.age;
    mode = "0664";
  };
  age.secrets.gh = {
    file = ./gh.age;
    mode = "0664";
  };
  age.secrets."resilio-p" = {
    file = ./resilio-p.age;
    mode = "0664";
  };
  age.secrets."resilio-docs" = {
    file = ./resilio-docs.age;
    mode = "0664";
  };
  age.secrets."resilio-shared-public" = {
    file = ./resilio-shared-public.age;
    mode = "0664";
  };
  age.secrets.netdata = {
    file = ./netdata.age;
    mode = "0664";
  };
}
