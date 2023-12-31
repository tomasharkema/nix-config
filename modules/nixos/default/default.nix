{
  pkgs,
  lib,
  ...
}: {
  config = with lib; {
    # Set your time zone.
    time.timeZone = "Europe/Amsterdam";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_IDENTIFICATION = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
    };

    environment.systemPackages = with pkgs; [
      atop
      packagekit
      fwupd
      fwupd-efi
      toybox
      dconf2nix
    ];

    # services.eternal-terminal.enable = true;

    services.openssh = {
      enable = true;
      # require public key authentication for better security
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "yes";
    };

    programs.ssh.startAgent = true;

    system.autoUpgrade.enable = true;

    systemd.targets.sleep.enable = mkDefault false;
    systemd.targets.suspend.enable = mkDefault false;
    systemd.targets.hibernate.enable = mkDefault false;
    systemd.targets.hybrid-sleep.enable = mkDefault false;

    # systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
    # systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

    services.fwupd.enable = true;
    networking.firewall = {
      enable = mkDefault true;
    };

    services.avahi.extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
    };
    services.udev = {enable = lib.mkDefault true;};
  };
}
