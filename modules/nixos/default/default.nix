{
  pkgs,
  lib,
  ...
}: {
  config = {
    time.timeZone = "Europe/Amsterdam";

    environment.systemPackages = with pkgs; [
      atop
      packagekit
      fwupd
      fwupd-efi
      toybox
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

    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;

    # systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
    # systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

    services.fwupd.enable = true;
    networking.firewall = {
      enable = lib.mkDefault true;
    };

    services.avahi.extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
    };
    services.udev = {enable = lib.mkDefault true;};
  };
}
