{ pkgs, ... }: {

  time.timeZone = "Europe/Amsterdam";
  services.tailscale.enable = true;
  services.tailscale.authKeyFile = ../tailscalekey.conf;
  system.stateVersion = "23.11";
  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;

  users.users.tomas = {
    isNormalUser = true;
    description = "tomas";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [ firefox ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
    ];
  };

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
    claimTokenFile = ../cloudtoken.conf;
  };
  # environment.var."lib/netdata/cloud.d/token" = {
  #   mode = "0600";
  #   source = ./cloudtoken.conf;
  # };
}
