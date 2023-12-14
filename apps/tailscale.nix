{
  config,
  pkgs,
  modulesPath,
  lib,
  ...
}: {
  age.secrets.tailscale.file = ../secrets/tailscale.age;
  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale.path;
    useRoutingFeatures = "client";
    extraUpFlags = [
      # "--ssh"
      "--ssh=false"
      "--advertise-tags=tag:nixos"
      "--operator=tomas"
    ];
    openFirewall = true;
  };
  networking.nftables.enable = true;

  networking.firewall.trustedInterfaces = ["tailscale0"];
  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];

  services.avahi = {
    enable = true;
    # interfaces = [ "tailscale0" ];
    ipv6 = true;
    publish.enable = true;
    publish.userServices = true;
    publish.addresses = true;
    publish.domain = true;
    nssmdns = true;
    publish.workstation = true;
    openFirewall = true;
  };
}
