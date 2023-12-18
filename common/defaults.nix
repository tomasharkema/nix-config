{ config
, nixpkgs
, pkgs
, inputs
, ...
} @ attrs:
let
  lib = nixpkgs.lib;
  common = import ../packages/common.nix (attrs);
  gui = import ../packages/gui.nix (attrs);
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
      "https://nix-cache.harke.ma/"
      "https://cache.nixos.org/"
    ];
    extra-binary-caches = [
      "https://nix-cache.harke.ma/"
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [

      "nix-cache.harke.ma:2UhS18Tt0delyOEULLKLQ36uNX3/hpX4sH684B+cG3c="
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRn81Pxfg4ttTocQnTUWirpC1QVeJ5bfPC63ET9fNVa root@supermicro"
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

  services.avahi.extraServiceFiles = {
    ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
  };



  systemd.services.attic-watch =
    let
      attic-bin = lib.attrsets.getBin inputs.attic;
      attic-script = (pkgs.writeShellScriptBin "attic-script" ''
        ${lib.attrsets.getBin attic-bin}/bin/attic-bin watch-store tomas:tomas
      '');
    in
    {
      enable = true;
      description = "attic-watch";
      unitConfig = {
        Type = "simple";
        StartLimitIntervalSec = 500;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
      };
      script = "${lib.attrsets.getBin attic-script}/bin/attic-script";
      wantedBy = [ "multi-user.target" ];
      path = [ attic-bin attic-script ];
      environment = {
        ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
      };
    };
}
