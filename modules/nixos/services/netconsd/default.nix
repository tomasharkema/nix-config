{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.services.netconsoled;

  configFile = pkgs.writeText "config.yml" ''
    ---
    # Configuration of the netconsoled server.
    server:
      # Required: listen for incoming netconsole logs.
      udp_addr: :${toString cfg.port}
      # Optional: enable HTTP server for Prometheus metrics.
      http_addr: :8472
    # Zero or more filters to apply to incoming logs.
    filters:
      # By default, apply no filtering to logs.
      - type: noop
    # Zero or more sinks to use to store processed logs.
    sinks:
      # By default, print logs to stdout and to a file.
      - type: stdout
      - type: file
        file: /var/log/netconsoled/netconsoled.log
  '';
in {
  options.services.netconsoled = {
    enable = lib.mkEnableOption "enable netconsole daemon";
    port = lib.mkOption {
      description = "listen port";
      default = 6666;
      type = lib.types.int;
    };
  };

  config = lib.mkIf (cfg.enable && false) {
    networking.firewall.allowedUDPPorts = [cfg.port];

    systemd.services.netconsoled = {
      description = "netconsoled";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        RestartSec = 5;
        Type = "simple";
        ExecStart = "${pkgs.custom.netconsoled}/bin/netconsoled -c ${configFile}";
      };
    };
  };
}
