{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.apps.gpsd;
in {
  options.apps.gpsd = {
    enable = lib.mkEnableOption "enable gpsd";

    server.enable = lib.mkEnableOption "enable gpsd server";
  };

  config = lib.mkIf cfg.enable {
    services = {
      gpsd = {
        enable = true;
        devices = lib.mkIf cfg.server.enable (lib.mkForce ["/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_A50285BI-if00-port0"]);
        listenany = lib.mkIf cfg.server.enable true;
        debugLevel = lib.mkIf cfg.server.enable 5;
        readonly = lib.mkIf cfg.server.enable false;
        extraArgs = lib.mkIf cfg.server.enable [
          "-n"
        ];
      };
      geoclue2 = {
        enable = true;
        enableDemoAgent = lib.mkForce true;
      };
    };
    systemd = {
      services.gpsd = {
        requires = ["gpsd.socket"];
        wantedBy = ["gpsd.socket"];
        serviceConfig = lib.mkIf (!cfg.server.enable) {
          ExecStart = lib.mkForce "${pkgs.gpsd}/sbin/gpsd gpsd://raspi5.local";
        };
      };
      sockets.gpsd = {
        listenStreams = [
          "/run/gpsd.sock"
          "0.0.0.0:2947"
        ];
        wantedBy = ["sockets.target"];
        description = "gpsd socket";
        socketConfig.SocketMode = 0600;
      };
    };
  };
}
