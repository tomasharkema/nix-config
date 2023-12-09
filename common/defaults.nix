{ self, nixpkgs, pkgs, lib, inputs, outputs, ... }: {
  hardware.enableAllFirmware = true;
  system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
  system.stateVersion = "23.11";
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" "x86_64-linux" ];
  imports = [
    # inputs.home-manager.nixosModules.home-manager
    ./packages.nix
    ../apps/resilio.nix
    ../apps/tailscale.nix
  ];

  # nix = {
  #   extraOptions = ''
  #     extra-experimental-features = "nix-command flakes";

  #     extra-substituters = [ "https://cachix.cachix.org" "https://tomasharkema.cachix.org" ];
  #     extra-trusted-public-keys =  "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA=";
  #   '';
  # };
  nix.settings.trusted-users = [ "root" "tomas" ];

  programs.zsh = { enable = true; };
  users.users.tomas.shell = pkgs.zsh;

  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  security.sudo.wheelNeedsPassword = false;

  users.mutableUsers = false;
  nixpkgs.config.allowUnfree = true;

  users.users.tomas = {
    isNormalUser = true;
    description = "tomas";
    extraGroups = [ "networkmanager" "wheel" "rslsync" "tomas" ];
    hashedPassword =
      "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
    ];
  };

  services.eternal-terminal.enable = true;

  # users.users."tomas".hashedPassword =
  #   config.users.users."tomas".initialHashedPassword;

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

  networking.firewall = {
    # enable the firewall
    enable = true;

    #   # # allow the Tailscale UDP port through the firewall
    # allowedUDPPorts = [ 22 2022 9090 ];

    #   # # allow you to SSH in over the public internet
    # allowedTCPPorts = [ 22 2022 9090 ];
  };
}
