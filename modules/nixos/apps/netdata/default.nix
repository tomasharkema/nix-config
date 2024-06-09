{ config, pkgs, lib, ... }:
with lib;
with lib.custom;
let cfg = config.apps.netdata;
in {
  options.apps.netdata = { enable = mkBoolOpt true "netdata"; };

  config = mkIf cfg.enable {

    age.secrets.netdata = {
      file = ../../secrets/netdata.age;
      mode = "644";
    };

    services.netdata = {
      enable = true;
      package = pkgs.netdataCloud;
      claimTokenFile = config.age.secrets."netdata".path;
      python.enable = true;
      configDir = {
        "stream.conf" = pkgs.writeText "stream.conf" ''
          [stream]
            # Stream metrics to another Netdata
            enabled = yes
            # The IP and PORT of the parent
            destination = silver-star:19999
            # The shared API key, generated by uuidgen
            api key = f4066b91-24f2-4c54-8db8-23a49b023e9a
        '';
        "health_alarm_notify.conf" =
          pkgs.writeText "health_alarm_notify.conf" ''
            SEND_NTFY="YES"
            DEFAULT_RECIPIENT_NTFY="https://ntfy.sh/tomasharkema-nixos"
          '';
        "go.d/docker.conf" = pkgs.writeText "docker.conf" ''
          jobs:
            - name: local
              address: 'unix:///var/run/docker.sock'
        '';
      };
    };
  };
}
