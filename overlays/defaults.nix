{ pkgs, ... }: {

  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = "23.11";
  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;

  users.users.tomas = {
    isNormalUser = true;
    description = "tomas";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [ firefox tilix ];
    hashedPassword =
      "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";

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
    claimTokenFile = ../files/cloudtoken.conf;
  };

  services.tailscale = {
    enable = true;
    authKeyFile = ../files/tailscalekey.conf;
  };

  # system.autoUpgrade.enable = true;

  # systemd.services.NetworkManager-wait-online.enable = false;
}
