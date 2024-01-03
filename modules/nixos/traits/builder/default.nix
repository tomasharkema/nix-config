{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.builder;
in {
  imports = with inputs; [
    vscode-server.nixosModules.default
  ];

  options.traits = {
    builder = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    apps.attic.enable = true;

    # services.postgresql.enable = true;

    services.hydra = {
      enable = true;
      hydraURL = "hydra.harkema.io";
      notificationSender = "tomas+hydra@harkema.io";
      buildMachinesFiles = [];
      useSubstitutes = true;
      smtpHost = "smtp-relay.gmail.com";
      extraConfig = ''
        Include ${config.age.secrets.ght.path}
        <hydra_notify>
          <prometheus>
            listen_address = 127.0.0.1
            port = 9199
          </prometheus>
        </hydra_notify>
        <githubstatus>
          ## This example will match all jobs
          jobs = .*
          inputs = src
          excludeBuildFromContext = 1
        </githubstatus>
      '';
    };

    programs.ssh.extraConfig = ''
      StrictHostKeyChecking no
    '';
    nix = {
      extraOptions = ''
        auto-optimise-store = true
        allowed-uris = https://github.com/zhaofengli/nix-base32.git https://github.com/tomasharkema.keys https://git.sr.ht/~thatonelutenist/nix-cache-watcher https://api.flakehub.com/f/pinned https://github.com/NixOS/nixpkgs/archive https://github.com/NixOS/nixpkgs-channels/archive https://github.com/input-output-hk https://github.com/tomasharkema
      '';
      binaryCaches = mkForce ["https://cache.nixos.org"];
      settings.trusted-users = ["hydra" "hydra-queue-runner" "hydra-www"];
    };

    programs.nix-ld.enable = true;

    nix.sshServe = {
      # enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas@tomas"
      ];
    };

    services.vscode-server.enable = true;
  };
}
