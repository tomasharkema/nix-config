{ lib, config, ... }: {
  config = {
    age = {
      identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      secrets = {
        atuin = {
          file = ./atuin.age;
          owner = "tomas";
          group = "tomas";
          mode = "644";
          # symlink = false;
        };
        "attic-config.toml" = {
          file = ./attic-config.toml.age;
          mode = "644";
          owner = "tomas";
          group = "tomas";
          path = "/home/tomas/.config/attic/config.toml";
        };
        "attic-netrc" = {
          file = ./attic-netrc.age;
          mode = "644";
          owner = "tomas";
          group = "tomas";
          path = "/home/tomas/.config/attic/netrc";
        };
        attic-key = {
          file = ./attic-key.age;
          mode = "644";
        };
        ght = {
          file = ./ght.age;
          mode = "0664";
        };
        tailscale = {
          file = ./tailscale.age;
          mode = "644";
        };
        gh = {
          file = ./gh.age;
          mode = "644";
        };
        "resilio-p" = {
          file = ./resilio-p.age;
          mode = "644";
        };
        "resilio-docs" = {
          file = ./resilio-docs.age;
          mode = "644";
        };
        "resilio-shared-public" = {
          file = ./resilio-shared-public.age;
          mode = "644";
        };
        netdata = {
          file = ./netdata.age;
          mode = "644";
        };
        # "cachix" = {
        #   file = ./cachix.age;
        #   mode = "644";
        #   path = "/etc/cachix.dhall";
        # path = "/home/tomas/.config/cachix/cachix.dhall";
        # owner = "tomas";
        # group = "tomas";
        # };
        # "cachix-root" = {
        #   file = ./cachix.age;
        #   mode = "644";
        #   path = "/root/.config/cachix/cachix.dhall";
        # };
        # "cachix-agent" = {
        #   file = ./cachix-agent.age;
        #   mode = "644";
        #   path = "/etc/cachix-agent.token";
        # };
        # "cachix-token" = {
        #   file = ./cachix-token.age;
        #   mode = "744";
        # };
        # "cachix-activate" = {
        #   file = ./cachix-activate.age;
        #   mode = "644";
        # };
        # age.secrets."otp" = {
        #   file = ./otp.age;
        #   mode = "644";
        #   # path = "/home/tomas/.google_authenticator";
        #   # owner = "tomas";
        #   # group = "tomas";
        # };
        "healthcheck" = {
          file = ./healthcheck.age;
          mode = "644";
        };
        "op" = {
          file = ./op.age;
          mode = "644";
        };
        # spotify-tui = {
        #   file = ./spotify-tui.age;
        #   # owner = "tomas";
        #   # group = "tomas";
        #   mode = "644";
        #   # symlink = false;
        # };

        notify = {
          file = ./notify.age;
          # owner = "tomas";
          # group = "tomas";
          mode = "644";
          # path = "/home/tomas/.config/notify/provider-config.yaml";
          # symlink = false;
        };
        mak = {
          file = ./mak.age;
          mode = "644";
        };
        # "hercules-cli.key" = {
        #   file = ./hercules-cli.key.age;
        #   mode = "644";
        #   path = "/var/lib/hercules-ci-agent/secrets/cluster-join-token.key";
        # };
        "domainjoin" = { file = ./domainjoin.age; };
        "peerix-private" = {
          file = ./peerix.private.age;
          mode = "644";
        };
      };
    };
  };
}
