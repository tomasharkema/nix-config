{ config
, pkgs
, modulesPath
, lib
, tailscale-prometheus-sd

, ...
}: {
  age.secrets.tailscale.file = ../secrets/tailscale.age;
  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale.path;
    useRoutingFeatures = "client";
    extraUpFlags = [
      "--ssh=false"
      "--advertise-tags=tag:nixos"
      "--operator=tomas"
    ];
    openFirewall = true;
  };
  networking.nftables.enable = true;

  networking.firewall.trustedInterfaces = [ "tailscale0" "zthnhagpcb" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  services.avahi = {
    enable = true;
    interfaces = [ "zthnhagpcb" ];
    ipv6 = true;
    publish.enable = true;
    publish.userServices = true;
    publish.addresses = true;
    publish.domain = true;
    nssmdns = true;
    publish.workstation = true;
    # openFirewall = true;
    reflector = true;
  };

  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "af78bf9436bca877" ];

  # tailscale-prometheus-sd
  systemd.services.tailscale-sd = {
    enable = true;
    description = "tailscale-prometheus-sd";
    unitConfig = {
      Type = "simple";
      StartLimitIntervalSec = 500;
      StartLimitBurst = 5;
    };
    serviceConfig = {
      ExecStart = "${tailscale-prometheus-sd.packages.x86_64-linux.default}";
      Restart = "on-failure";
      RestartSec = 5;
    };
    # wantedBy = ["graphical-session.target"];
  };
}
