{ config, pkgs, lib, ... }:
with lib;
let
  sendmail = pkgs.writeScript "sendmail" ''
    #!/bin/sh
    ${pkgs.system-sendmail}/bin/sendmail -t <<ERRMAIL
    To: $1
    From: tomas@harkema.io
    Subject: Status of service $2 on $HOSTNAME
    Content-Transfer-Encoding: 8bit
    Content-Type: text/plain; charset=UTF-8
    ```
    $(systemctl status --full "$2")
    ```
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

    systemd.services."${notifyServiceName}@" = {
      description = "Send Pseudo Notification";
      onFailure = mkForce [ ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${sendmail} all@mailrise.xyz %i";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
