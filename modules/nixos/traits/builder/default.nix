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

        <dynamicruncommand>
          enable = 1
        </dynamicruncommand>
        <hydra_notify>
          <prometheus>
            listen_address = 127.0.0.1
            port = 9199
          </prometheus>
        </hydra_notify>
      '';
    };

    system.activationScripts = {
      hydraSshFile.text = ''
        cat <<EOT > /var/lib/hydra/.ssh/config
        Host github.com
          StrictHostKeyChecking No
          UserKnownHostsFile /dev/null
          IdentityFile /var/lib/hydra/.ssh/id_ed25519
        EOT
      '';
    };
    programs.nix-ld.enable = true;

    nix.sshServe = {
      enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas@tomas"
      ];
    };

    services.vscode-server.enable = true;
  };
}
