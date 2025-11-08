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
          owner = "${config.user.name}";
          group = "${config.user.name}";
          mode = "644";
          # symlink = false;
        };

        # tailscale = {
        #   rekeyFile = ./tailscale.age;
        #   mode = "644";
        # };
        # gh = {
        #   rekeyFile = ./gh.age;
        #   mode = "644";
        # };
        "ntfy" = {
          rekeyFile = ./ntfy.age;
          mode = "644";
        };

        # "cachix" = {
        #   rekeyFile = ./cachix.age;
        #   mode = "644";
        #   path = "/etc/cachix.dhall";
        # path = "/home/tomas/.config/cachix/cachix.dhall";
        # owner = "tomas";
        # group = "tomas";
        # };
        # "cachix-root" = {
        #   rekeyFile = ./cachix.age;
        #   mode = "644";
        #   path = "/root/.config/cachix/cachix.dhall";
        # };
        # "cachix-agent" = {
        #   rekeyFile = ./cachix-agent.age;
        #   mode = "644";
        #   path = "/etc/cachix-agent.token";
        # };
        # "cachix-token" = {
        #   rekeyFile = ./cachix-token.age;
        #   mode = "744";
        # };
        # "cachix-activate" = {
        #   rekeyFile = ./cachix-activate.age;
        #   mode = "644";
        # };
        # age.secrets."otp" = {
        #   rekeyFile = ./otp.age;
        #   mode = "644";
        #   # path = "/home/tomas/.google_authenticator";
        #   # owner = "tomas";
        #   # group = "tomas";
        # };
        # "healthcheck" = {
        #   rekeyFile = ./healthcheck.age;
        #   mode = "644";
        # };
        # "op" = {
        #   rekeyFile = ./op.age;
        #   mode = "644";
        # };
        # spotify-tui = {
        #   rekeyFile = ./spotify-tui.age;
        #   # owner = "tomas";
        #   # group = "tomas";
        #   mode = "644";
        #   # symlink = false;
        # };

        # notify = {
        #   rekeyFile = ./notify.age;
        #   # owner = "tomas";
        #   # group = "tomas";
        #   mode = "644";
        #   # path = "/home/tomas/.config/notify/provider-config.yaml";
        #   # symlink = false;
        # };
        # mak = {
        #   rekeyFile = ./mak.age;
        #   mode = "644";
        # };

        # "domainjoin" = {
        #   rekeyFile = ./domainjoin.age;
        # };
        # netrc = {
        #   rekeyFile = ./netrc.age;
        # };
      };
    };
  };
}
