{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.usb-over-ethernet;
in {
  options.services.usb-over-ethernet = {
    enable = lib.mkEnableOption "usb-over-ethernet";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.custom.usb-over-ethernet pkgs.usbview];
    systemd.packages = [pkgs.custom.usb-over-ethernet];

    systemd.services = {
      "eveusbd" = {
        description = "eveusbd";
        enable = true;
        path = [pkgs.custom.usb-over-ethernet];

        script = "eveusbd -p -L info";

        wantedBy = ["default.target"];

        serviceConfig = {
          WorkingDirectory = "/var/lib/eveusb";
          StateDirectory = ["eveusb"];
          ConfigurationDirectory = ["eveusb"];
          DynamicUser = true;
          User = "eveusb";
          Group = "eveusb";
        };
      };
    };
  };
}
