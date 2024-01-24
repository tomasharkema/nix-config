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
      mode = "644";
      # symlink = false;
    };
    age.secrets.attic-key = {
      file = ./attic-key.age;
      mode = "644";
    };
    age.secrets.tailscale = {
      file = ./tailscale.age;
      mode = "644";
    };
    age.secrets.gh = {
      file = ./gh.age;
      mode = "644";
    };
    age.secrets."resilio-p" = {
      file = ./resilio-p.age;
      mode = "644";
    };
    age.secrets."resilio-docs" = {
      file = ./resilio-docs.age;
      mode = "644";
    };
    age.secrets."resilio-shared-public" = {
      file = ./resilio-shared-public.age;
      mode = "644";
    };
    age.secrets.netdata = {
      file = ./netdata.age;
      mode = "644";
    };
    age.secrets."cachix" = {
      file = ./cachix.age;
      mode = "644";
      path = "/etc/cachix.dhall";
      # path = "/home/tomas/.config/cachix/cachix.dhall";
      # owner = "tomas";
      # group = "tomas";
    };
    # age.secrets."cachix-root" = {
    #   file = ./cachix.age;
    #   mode = "644";
    #   path = "/root/.config/cachix/cachix.dhall";
    # };
    age.secrets."cachix-agent" = {
      file = ./cachix-agent.age;
      mode = "644";
      path = "/etc/cachix-agent.token";
    };
    age.secrets."cachix-token" = {
      file = ./cachix-token.age;
      mode = "744";
    };
    age.secrets."cachix-activate" = {
      file = ./cachix-activate.age;
      mode = "644";
    };
    # age.secrets."otp" = {
    #   file = ./otp.age;
    #   mode = "644";
    #   # path = "/home/tomas/.google_authenticator";
    #   # owner = "tomas";
    #   # group = "tomas";
    # };
    age.secrets."healthcheck" = {
      file = ./healthcheck.age;
      mode = "644";
    };
    age.secrets."op" = {
      file = ./op.age;
      mode = "644";
    };
    age.secrets.spotify-tui = {
      file = ./spotify-tui.age;
      # owner = "tomas";
      # group = "tomas";
      mode = "644";
      # symlink = false;
    };
  };
}
