{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wifi;

  getFileName = lib.stringAsChars (x:
    if x == " "
    then "-"
    else x);

  createWifi = ssid: opt: {
    name = ''
      NetworkManager/system-connections/${getFileName ssid}.nmconnection
    '';
    value = {
      mode = "0400";
      source = pkgs.writeText "${ssid}.nmconnection" ''
        [connection]
        id=${ssid}
        type=wifi

        [wifi]
        ssid=${ssid}

        [wifi-security]
        ${lib.optionalString (opt.psk != null) ''
          key-mgmt=wpa-psk
          psk=${opt.psk}''}
      '';
    };
  };

  keyFiles = lib.mapAttrs' createWifi config.networking.wireless.networks;
in {
  config = lib.mkIf cfg.enable {
    environment.etc = keyFiles;

    systemd.services.NetworkManager-predefined-connections = {
      restartTriggers = lib.mapAttrsToList (name: value: value.source) keyFiles;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/true";
        ExecReload = "${pkgs.networkmanager}/bin/nmcli connection reload";
      };
      reloadIfChanged = true;
      wantedBy = ["multi-user.target"];
    };
  };
}
