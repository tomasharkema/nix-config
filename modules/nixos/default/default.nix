{
  config,
  pkgs,
  lib,
  ...
}: {
  config = let
    papertrail-pem = pkgs.fetchurl {
      url = " https://papertrailapp.com/tools/papertrail-bundle.pem";
      sha256 = "sha256-rjHss8bp/zFUy3pV8BcJBEj4hILw6UrJJ8DGeh8zuc8=";
    };
  in
    with lib; {
      # Set your time zone.
      time.timeZone = "Europe/Amsterdam";
      # services.das_watchdog.enable = true;
      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      #services.cachix-agent.enable = true;

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
        hw-probe
        git
        wget
        curl
        freeipa
      ];

      # services.thermald.enable = true;

      # services.eternal-terminal.enable = true;

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "yes";
        };
      };

      programs.ssh.startAgent = true;

      system.autoUpgrade.enable = true;

      systemd.targets.sleep.enable = mkDefault false;
      systemd.targets.suspend.enable = mkDefault false;
      systemd.targets.hibernate.enable = mkDefault false;
      systemd.targets.hybrid-sleep.enable = mkDefault false;

      systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
      systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

      services.fwupd.enable = true;
      networking.firewall = {
        enable = mkDefault true;
      };

      services.avahi.extraServiceFiles = {
        ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
      };
      services.udev = {enable = lib.mkDefault true;};
      programs.zsh.shellInit = ''
        source ${config.age.secrets."cachix-activate".path}
      '';

      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      };
      # services.sssd.sshAuthorizedKeysIntegration = true;
      networking.extraHosts = ''
        192.168.0.15 ipa.harkema.io
      '';
      # security.ipa = {
      #   enable = true;
      #   server = "ipa.harkema.io";
      #   domain = "harkema.io";
      #   realm = "HARKEMA.IO";
      #   basedn = "dc=harkema,dc=io";
      #   certificate = pkgs.fetchurl {
      #     url = "https://ipa.harkema.io/ipa/config/ca.crt";
      #     sha256 = "sha256-3XRsoBALVsBVG9HQfh9Yq/OehvPPiOuZesSgtWXh74I=";
      #   };
      #   dyndns.enable = true; # TODO: enable this??
      # };
      documentation.nixos.enable = false;

      services.rsyslogd = {
        enable = true;

        extraConfig = ''
          $DefaultNetstreamDriverCAFile ${papertrail-pem}
          $ActionSendStreamDriver gtls
          $ActionSendStreamDriverMode 1
          $ActionSendStreamDriverAuthMode x509/name
          $ActionSendStreamDriverPermittedPeer *.papertrailapp.com

          *.*    @@logs2.papertrailapp.com:42640
        '';
      };
    };
}
