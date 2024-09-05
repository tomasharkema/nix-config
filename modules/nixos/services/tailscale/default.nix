{
  config,
  pkgs,
  modulesPath,
  lib,
  ...
}: let
  cfg = config.tailscale;
in {
  options.tailscale = {
    enable = lib.mkEnableOption "SnowflakeOS GNOME configuration" // {default = true;};
  };

  # age.secrets.tailscale = {
  #   rekeyFile = ../../secrets/tailscale.age;
  #   # mode = "770";
  #   owner = "tomas";
  #   group = "tomas";
  # };

  config = lib.mkIf cfg.enable {
    networking = {
      useDHCP = false;

      # iptables.enable = true;

      firewall = {
        trustedInterfaces = [
          "tailscale0"
          "zthnhagpcb"
        ];
        allowedTCPPorts = [config.services.tailscale.port];
        allowedUDPPorts = [config.services.tailscale.port];
      };
    };

    services = {
      resolved.enable = true;

      tailscale = {
        enable = true;
        package = pkgs.tailscale;
        authKeyFile = config.age.secrets.tailscale.path;
        useRoutingFeatures = "both";
        extraUpFlags = [
          "--advertise-tags=tag:nixos"
          "--operator=tomas"
          "--accept-dns"
          # "--accept-routes"
        ];
        openFirewall = true;
      };

      avahi = {
        enable = true;
        # allowInterfaces = [ "zthnhagpcb" "tailscale0" ];
        ipv6 = true;
        publish.enable = true;
        publish.userServices = true;
        publish.addresses = true;
        publish.domain = true;
        publish.hinfo = true;
        nssmdns = true;
        publish.workstation = true;
        openFirewall = true;
        # reflector = true;
      };

      zerotierone = {
        enable = true;
        joinNetworks = ["***REMOVED***"];
      };
    };

    systemd.services.tailscalesd = {
      enable = true;
      description = "tailscale-prometheus-sd";
      unitConfig = {
        Type = "simple";
        StartLimitIntervalSec = 500;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
      };
      script = "${lib.getExe pkgs.tailscalesd} --localapi";
      wantedBy = ["multi-user.target"];
      after = ["tailscale.service"];
      wants = ["tailscale.service"];
      # path = [pkgs.tailscale pkgs.custom.tailscalesd];
      # environment = {
      #   ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
      # };
    };
  };
}
