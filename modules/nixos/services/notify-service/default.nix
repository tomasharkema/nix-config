{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  notifyServiceName = "notify-service";
in {
  options.systemd.services = mkOption {
    type = with types;
      attrsOf (submodule {
        config.onFailure = ["${notifyServiceName}@%n.service"];
      });
  };

  config = {
    # services.atd = {
    #   enable = true;
    #   allowEveryone = true;
    # };

    systemd.services = {
      "${notifyServiceName}@" = {
        description = "Send onFailure Notification";
        onFailure = mkForce [];

        serviceConfig = {
          Type = "oneshot";
          EnvironmentFile = config.age.secrets."notify-sub".path;
          ExecStart = "/bin/sh -c '${pkgs.ntfy-sh}/bin/ntfy publish --title \"$HOSTNAME Status of %i\" \"$NIXOS_TOPIC_NAME\" \"$(systemctl status --full %i)\"'";
        };
        wantedBy = ["default.target"];
        after = ["network-online.target"];
        wants = ["network-online.target"];
      };
    };
  };
}
