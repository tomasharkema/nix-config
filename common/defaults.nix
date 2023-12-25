{
  config,
  pkgs,
  inputs,
  lib,
  ...
} @ attrs: let
  # lib = nixpkgs.lib;
  common = import ../packages/common.nix attrs;
  # gui = import ../packages/gui.nix (attrs);
in {
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  # system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

  system.stateVersion = "23.11";

  imports = [
    ../apps/resilio.nix
    ../apps/tailscale
    ./users.nix
    ../apps/cockpit.nix
    ../apps/prometheus
    ../apps/kdeconnect

    ../apps/keybase
  ];

  environment.pathsToLink = ["/share/zsh"];
  programs.zsh.enable = true;
  environment.systemPackages = common; # ++ gui;

  networking.wireless.enable = lib.mkDefault false;
  networking.networkmanager.enable = lib.mkDefault true;

  time.timeZone = "Europe/Amsterdam";

  # services.eternal-terminal.enable = true;

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  age.secrets."netdata" = {file = ../secrets/netdata.age;};
  services.netdata = {
    enable = true;
    package = pkgs.netdata.override {withCloud = true;};
    claimTokenFile = config.age.secrets."netdata".path;
  };
  programs.ssh.startAgent = true;
  system.autoUpgrade.enable = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  # systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  nix.optimise.automatic = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.fwupd.enable = true;
  networking.firewall = {
    enable = lib.mkDefault true;
  };

  services.avahi.extraServiceFiles = {
    ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
  };
  services.udev = {enable = lib.mkDefault true;};

  nix.gc = {
    automatic = true;
    options = ''
      --delete-older-than "7d"
    '';
  };
  programs.nix-ld.enable = true;
}
