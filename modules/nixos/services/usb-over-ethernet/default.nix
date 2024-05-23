{ pkgs, lib, config, ... }:
with lib;
let cfg = config.services.usb-over-ethernet;
in {
  options.services.usb-over-ethernet = {
    enable = mkEnableOption "usb-over-ethernet";
  };

  config = mkIf cfg.enable {

    systemd.services = {

      "eveusbd" = {
        description = "eveusbd";
        enable = true;
        path = [ pkgs.custom.usb-over-ethernet ];
        script = "eveusbd";

        wantedBy = [ "default.target" ];
      };
    };
  };
}
