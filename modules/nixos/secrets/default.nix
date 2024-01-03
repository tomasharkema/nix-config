{
  lib,
  config,
  ...
}: {
  config = {
    age.identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    age.secrets.atuin = {
      file = ./atuin.age;
      owner = "tomas";
      group = "tomas";
      path = "/tmp/atuin.key";
    };
    age.secrets.attic-key = {
      file = ./attic-key.age;
      mode = "0664";
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
    age.secrets.ght = {
      file = ./ght.age;
      mode = "0664";
    };
    age.secrets."ght-runner" = {
      file = ./ght-runner.age;
      mode = "0664";
    };
  };
}
