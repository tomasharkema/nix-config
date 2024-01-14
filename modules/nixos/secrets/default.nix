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
    age.secrets."cachix" = {
      file = ./cachix.age;
      mode = "777";
      path = "/etc/cachix.dhall";
      # path = "/home/tomas/.config/cachix/cachix.dhall";
      # owner = "tomas";
      # group = "tomas";
    };
    # age.secrets."cachix-root" = {
    #   file = ./cachix.age;
    #   mode = "0664";
    #   path = "/root/.config/cachix/cachix.dhall";
    # };
    age.secrets."cachix-agent" = {
      file = ./cachix-agent.age;
      mode = "770";
      path = "/etc/cachix-agent.token";
    };
    # age.secrets."cachix-activate" = {
    #   file = ./cachix-activate.age;
    #   mode = "770";
    #   path = "/tmp/cacheix-act.sh";
    # };
    age.secrets."otp" = {
      file = ./otp.age;
      mode = "770";
      # path = "/home/tomas/.google_authenticator";
      # owner = "tomas";
      # group = "tomas";
    };
  };
}
