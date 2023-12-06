{ config, pkgs, lib, ... }: {
  imports = [ ./packages.nix ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = "23.11";
  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = false;

  users.users.tomas = {
    isNormalUser = true;
    description = "tomas";
    extraGroups = [ "networkmanager" "wheel" ];
    initialHashedPassword =
      "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
    ];
  };

  users.users."tomas".hashedPassword =
    config.users.users."tomas".initialHashedPassword;

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  services.netdata = {
    enable = true;
    package = pkgs.netdata.override { withCloud = true; };
    claimTokenFile = ../files/cloudtoken.conf;
  };

  services.tailscale = {
    enable = true;
    authKeyFile = ../files/tailscalekey.conf;
    useRoutingFeatures = "client";
  };
  networking.nftables.enable = true;

  networking.firewall = {
    # enable the firewall
    enable = false;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [ 22 ];
  };

  system.autoUpgrade.enable = true;
  services.cockpit = {
    enable = true;
    port = 9090;
    settings = { WebService = { AllowUnencrypted = true; }; };
  };
  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # networking.networkmanager.unmanaged = [ "tailscale0" ];

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  # systemd.services.NetworkManager-wait-online.enable = false;

  nix.optimise.automatic = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
