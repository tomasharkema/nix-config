# {
#   config,
#   pkgs,
#   lib,
#   ...
# }: let
#   notifyServiceName = "notify-service";
#   ntfyScript = pkgs.writeShellScript "ntfy-script" ''
#     ${pkgs.ntfy-sh}/bin/ntfy publish --title "$HOSTNAME Status of $1" "$NIXOS_TOPIC_NAME" "$(systemctl status --full $1)"
#   '';
# in {
#   # options.systemd.services = lib.mkOption {
#   #   type = with lib.types;
#   #     attrsOf (submodule {
#   #       config.onFailure = ["${notifyServiceName}@%n.service"];
#   #     });
#   # };
#   config = {
#     # services.atd = {
#     #   enable = true;
#     #   allowEveryone = true;
#     # };
#     # systemd.services = {
#     #   "${notifyServiceName}@" = {
#     #     description = "Send onFailure Notification";
#     #     onFailure = lib.mkForce [];
#     #     path = [pkgs.bash];
#     #     serviceConfig = {
#     #       Type = "oneshot";
#     #       EnvironmentFile = config.age.secrets."notify-sub".path;
#     #       ExecStart = "${ntfyScript} %i";
#     #     };
#     #     wantedBy = ["default.target"];
#     #     after = ["network-online.target"];
#     #     wants = ["network-online.target"];
#     #   };
#     # };
#   };
# }
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  checkConditions = pkgs.writeScript "checkConditions" ''
    #!/bin/sh
    STATUS=$(systemctl status --full "$1")

    case "$STATUS" in
      *"activating (auto-restart) (Result: timeout)"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '';

  sendmail =
    pkgs.writeScript "sendmail"
    ''
      #!/bin/sh

      ${pkgs.ntfy-sh}/bin/ntfy publish \
        --title "Status of service $1 on $HOSTNAME" \
        "$NIXOS_TOPIC_NAME" \
        "$(systemctl status --full $1)"
    '';
in {
  options = {
    # systemd.email-notify.mailTo = mkOption {
    #   type = types.str;
    #   default = null;
    #   description = "Email address to which the service status will be mailed.";
    # };

    # systemd.email-notify.mailFrom = mkOption {
    #   type = types.str;
    #   default = null;
    #   description = "Email address from which the service status will be mailed.";
    # };

    systemd.services = mkOption {
      type = with types;
        attrsOf (
          submodule {
            config.onFailure = ["email@%n.service"];
          }
        );
    };
  };

  config = lib.mkIf false {
    systemd.services."email@" = {
      description = "Sends a status mail via sendmail on service failures.";
      onFailure = mkForce [];
      unitConfig = {
        StartLimitIntervalSec = "5m";
        StartLimitBurst = 1;
      };
      serviceConfig = {
        EnvironmentFile = config.age.secrets."notify-sub".path;
        ExecCondition = "${checkConditions} %i";
        ExecStart = "${sendmail} %i";
        Type = "oneshot";
      };
    };
  };
}
