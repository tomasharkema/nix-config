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
        # package = pkgs.geoclue2.overrideAttrs {
        #   version = "unstable";
        #   src = pkgs.custom.geoclue-gpsd.src;

        # postInstall = ''
        #   substituteInPlace $out/lib/systemd/system/geoclue.service \
        #     --replace-fail "Environment=\"GSETTINGS_BACKEND=memory\"" ""
        # '';
        #};
        enableDemoAgent = lib.mkForce true;
      };
    };

    systemd = {
      services.gpsd = {
        requires = ["gpsd.socket"];
        wantedBy = ["gpsd.socket"];
        serviceConfig = lib.mkIf (!cfg.server.enable) {
          ExecStart = lib.mkForce "${pkgs.gpsd}/sbin/gpsd gpsd://timepi.local";
        };
      };
      sockets.gpsd = {
        listenStreams = [
          "/run/gpsd.sock"
          "0.0.0.0:2947"
          # "[::]:2947"
        ];
        wantedBy = ["sockets.target"];
        description = "gpsd socket";
        socketConfig.SocketMode = 0600;
      };
    };
  };
}
