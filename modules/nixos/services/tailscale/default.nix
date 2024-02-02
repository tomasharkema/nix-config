{
  config,
  pkgs,
  modulesPath,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.tailscale;
in {
  options.tailscale = {
    enable = mkBoolOpt true "SnowflakeOS GNOME configuration";
  };

  # age.secrets.tailscale = {
  #   file = ../../secrets/tailscale.age;
  #   # mode = "770";
  #   owner = "tomas";
  #   group = "tomas";
  # };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale.path;
      useRoutingFeatures = "client";
      extraUpFlags = [
        "--ssh=false"
        "--advertise-tags=tag:nixos"
        "--operator=tomas"
        "--accept-dns"
        # "--accept-routes"
        # "--webclient"
      ];
      openFirewall = true;
    };

    networking.nftables.enable = true;

    networking.firewall.trustedInterfaces = ["tailscale0" "zthnhagpcb"];
    networking.firewall.allowedUDPPorts = [config.services.tailscale.port];

    services.avahi = {
      enable = true;
      allowInterfaces = ["zthnhagpcb" "tailscale0"];
      ipv6 = false;
      publish.enable = true;
      publish.userServices = true;
      publish.addresses = true;
      publish.domain = true;
      publish.hinfo = true;
      nssmdns = true;
      publish.workstation = true;
      openFirewall = true;
      reflector = true;
    };

    services.zerotierone.enable = true;
    services.zerotierone.joinNetworks = ["***REMOVED***"];

    systemd.packages = [
      pkgs.custom.tailscalesd
      pkgs.tailscale
    ];

    # systemd.services.tailscalesd = {
    #   enable = true;
    #   description = "tailscale-prometheus-sd";
    #   unitConfig = {
    #     Type = "simple";
    #     StartLimitIntervalSec = 500;
    #     StartLimitBurst = 5;
    #   };
    #   serviceConfig = {
    #     Restart = "on-failure";
    #     RestartSec = 5;
    #   };
    #   script = "${lib.attrsets.getBin pkgs.custom.tailscalesd}/bin/tailscalesd --localapi";
    #   wantedBy = ["multi-user.target"];
    #   after = ["tailscale.service"];
    #   wants = ["tailscale.service"];
    #   path = [pkgs.tailscale pkgs.custom.tailscalesd];
    #   environment = {
    #     ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
    #   };
    # };
  };
}
