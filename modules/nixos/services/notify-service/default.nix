{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  checkConditions = pkgs.writeShellScript "checkConditions" ''
    STATUS=$(systemctl status --full "$1")
    case "$STATUS" in
      *"activating (auto-restart) (Result: timeout)"*) exit 1 ;;
      *) exit 0 ;;
    esac
  '';
  # sendmail =
  #   pkgs.writeScript "sendmail"
  #   ''
  #     #!/bin/sh
  #     ${pkgs.ntfy-sh}/bin/ntfy publish \
  #       --title "Status of service $1 on $HOSTNAME" \
  #       "$NIXOS_TOPIC_NAME" \
  #       "$(systemctl status --full $1)"
  #   '';
  sendmail = pkgs.writeShellScript "sendmail" ''
    ${pkgs.systemd}/bin/systemctl status --full $1 | \
      ${pkgs.mailutils}/bin/mail -a "Content-Type: text/plain; charset=UTF-8" \
        -s "$HOSTNAME $1 service status" systemd@mailrise.xyz
  '';
in {
  options = {
    systemd.services = mkOption {
      type = with types;
        attrsOf (
          submodule {
            config.onFailure = ["systemd-email@%n.service"];
          }
        );
    };
  };

  config = {
    systemd.services = {
      "systemd-email@" = {
        description = "Sends a status mail via sendmail on service failures.";
        onFailure = mkForce [];
        unitConfig = {
          StartLimitIntervalSec = "5m";
          StartLimitBurst = 1;
          DefaultDependencies = "no";
        };
        serviceConfig = {
          EnvironmentFile = config.age.secrets."notify-sub".path;
          ExecCondition = "${checkConditions} %i";
          ExecStart = "${sendmail} %i";
          Type = "oneshot";
        };
      };
      # "systemd-alert" = {
      #   description = "Sends a status mail via sendmail on service failures.";
      #   serviceConfig = {
      #     ExecStart = "${lib.getExe pkgs.custom.systemd-alert} debug";
      #     Type = "simple";
      #   };
      #   wantedBy = ["multi-user.target"];
      # };
    };
    services.postfix = {
      enable = true;
      settings.main.relayhost = ["silver-star.ling-lizard.ts.net:8025"];
    };
  };
}
