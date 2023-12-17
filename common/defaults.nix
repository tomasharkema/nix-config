{ self
, config
, nixpkgs
, pkgs
, lib
, inputs
, outputs
, ...
} @ attrs:
let
  common = import ../packages/common.nix { inherit pkgs inputs; };
  gui = import ../packages/gui.nix { inherit pkgs; };
in
{
  hardware.enableAllFirmware = true;
  # system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
  system.stateVersion = "23.11";
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" "x86_64-linux" ];
  imports = [ ../apps/resilio.nix ../apps/tailscale ];

  environment.systemPackages = common ++ gui;

  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  nix.settings = {
    extra-experimental-features = "nix-command flakes";
    # distributedBuilds = true;
    trusted-users = [ "root" "tomas" ];
    extra-substituters = [
      # "ssh://nix-ssh@tower.ling-lizard.ts.net"
      "https://nix-cache.harke.ma/"
      # "https://tomasharkema.cachix.org/"
      "https://cache.nixos.org/"
    ];
    extra-binary-caches = [
      "https://nix-cache.harke.ma/"
      # "https://tomasharkema.cachix.org/"
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [
      "tower.ling-lizard.ts.net:MBxJ2O32x6IcWJadxdP42YGVw2eW2tAbMp85Ws6QCno="
      # "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
    ];
    access-tokens = [ "github.com=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" ];
  };

  programs.zsh = { enable = true; };
  users.users.tomas.shell = pkgs.zsh;

  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = false;

  users.users.tomas = {
    isNormalUser = true;
    description = "tomas";
    extraGroups = [ "networkmanager" "wheel" "rslsync" ];
    hashedPassword = "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@supermicro"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL68j0j9QNtaxySo9ysSV2n3xBcqc1aYzGFblwQvi1BQoQ4KIpCLkCxOx69yOdo/LwoCriyCmEEimqM0bEL3YZs="
    ];
  };
  users.groups.tomas = {
    name = "tomas";
    members = [ "tomas" ];
    gid = 1666;
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

  age.secrets."netdata" = { file = ../secrets/netdata.age; };
  services.netdata = {
    enable = true;
    package = pkgs.netdata.override { withCloud = true; };
    claimTokenFile = config.age.secrets."netdata".path;
  };
  programs.ssh.startAgent = true;
  system.autoUpgrade.enable = true;

  services.cockpit = {
    enable = true;
    port = 9090;
    settings = { WebService = { AllowUnencrypted = true; }; };
  };
  system.activationScripts = {
    cockpitXrdpCert = ''
      cd /etc/cockpit/ws-certs.d && ${pkgs.tailscale}/bin/tailscale cert $(hostname).ling-lizard.ts.net || true
    '';
  };

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
      systemd = {
        enable = true;
        port = 9003;
      };
      statsd = {
        enable = true;
        port = 9004;
      };
    };
  };

  services.cadvisor =
    {
      enable = true;

      port = 9005;
    };

  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  # systemd.services.NetworkManager-wait-online.enable = false;

  nix.optimise.automatic = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.fwupd.enable = true;
  networking.firewall = {
    enable = true;
    # enable = false;
  };
}
