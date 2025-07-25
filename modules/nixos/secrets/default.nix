{
  lib,
  config,
  ...
}: {
  config = {
    age = {
      secrets = {
        atuin = {
          rekeyFile = ./atuin.age;
          owner = "tomas";
          group = "tomas";
          mode = "644";
          # symlink = false;
        };
        "attic-config.toml" = {
          rekeyFile = ./attic-config.toml.age;
          mode = "644";
          owner = "tomas";
          group = "tomas";
        };

        # tailscale = {
        #   rekeyFile = ./tailscale.age;
        #   mode = "644";
        # };
        gh = {
          rekeyFile = ./gh.age;
          mode = "644";
        };
        "ntfy" = {
          rekeyFile = ./ntfy.age;
          mode = "644";
        };

        "healthcheck" = {
          rekeyFile = ./healthcheck.age;
          mode = "644";
        };
        "op" = {
          rekeyFile = ./op.age;
          mode = "644";
        };
        notify = {
          rekeyFile = ./notify.age;
          mode = "644";
        };
        mak = {
          rekeyFile = ./mak.age;
          mode = "644";
        };
        netrc = {
          rekeyFile = ./netrc.age;
        };
      };
    };
  };
}
