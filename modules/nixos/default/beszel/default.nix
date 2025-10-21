{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.services.beszel;
in {
  options.services.beszel = {
    enable = lib.mkEnableOption "beszel" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    # apps.docker.enable = true;

    systemd.services = {
      "beszel-agent" = {
        description = "Beszel Agent Service";
        wants = ["network-online.target"];
        after = ["network-online.target"];

        environment = {
          PORT = "45876";
          KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBb6gQ1tX2NulWR+f3X8oMSQsh0Is55vpaa8xxbU7Ay";
        };

        # Port number can be overridden in beszel-agent.conf if needed
        # EnvironmentFile=/etc/beszel-agent.conf

        serviceConfig = {
          StateDirectory = "beszel-agent";
          Restart = "on-failure";
          # User = "beszel";
          ExecStart = "${pkgs.beszel}/bin/beszel-agent";

          # Security/sandboxing settings
          # KeyringMode = "private";
          LockPersonality = "yes";
          ProtectClock = "yes";
          ProtectHome = "read-only";
          ProtectHostname = "yes";
          ProtectKernelLogs = "yes";
          ProtectSystem = "strict";
          RemoveIPC = "yes";
          RestrictSUIDSGID = "true";
        };

        wantedBy = ["multi-user.target"];
      };
    };

    # virtualisation.oci-containers.containers = {
    #   beszel-agent = {
    #     image = "henrygd/beszel-agent";

    #     volumes = [
    #       "/var/run/docker.sock:/var/run/docker.sock:ro"
    #     ];

    #     extraOptions = [
    #       "--privileged"
    #       "--net=host"
    #     ];

    #     environment = {
    #       PORT = "45876";
    #       KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHBb6gQ1tX2NulWR+f3X8oMSQsh0Is55vpaa8xxbU7Ay";
    #     };

    #     autoStart = true;
    #   };
    # };
  };
}
