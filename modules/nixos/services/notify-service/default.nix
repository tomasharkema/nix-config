{ config, pkgs, lib, ... }:
with lib;
let
  sendmail = pkgs.writeScript "sendmail" ''
    #!/bin/sh
    ${pkgs.system-sendmail}/bin/sendmail -t <<ERRMAIL
    To: systemd@mailrise.xyz
    From: tomas@harkema.io
    Subject: $HOSTNAME Status of service $1
    Content-Transfer-Encoding: 8bit
    Content-Type: text/plain; charset=UTF-8
    $(systemctl status --full "$1")
    ERRMAIL
  '';
  notifyServiceName = "notify-service";
in {

  options.systemd.services = mkOption {
    type = with types;
      attrsOf
      (submodule { config.onFailure = [ "${notifyServiceName}@%n.service" ]; });
  };

  config = {

    systemd.services = {
      "${notifyServiceName}@" = {
        description = "Send onFailure Notification";
        onFailure = mkForce [ ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${sendmail} %i";
        };
        wantedBy = [ "default.target" ];
      };
    };
  };
}
