{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  theme = inputs.themes.custom (inputs.themes.catppuccin-mocha
    // {
      base00 = "000000";
    });
in {
  options = {
    variables = lib.mkOption {
      type = lib.types.attrs;
      default = {
        theme = theme;
      };
    };
  };

  config = with lib; {
    # Set your time zone.
    time.timeZone = "Europe/Amsterdam";
    # services.das_watchdog.enable = true;
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # services.webhook = {
    #   enable = true;

    #   hooks = {
    #     echo = {
    #       execute-command = "echo";
    #       response-message = "Webhook is reachable!";
    #     };
    #   };
    # };

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

    boot.tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
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
      lm_sensors
      pciutils
      # cope
      pkgs.custom.menu
      #xpipe
      pkgs.custom.graylog-cli-dashboard

      notify
      pkgs.custom.pvzstd
    ];

    programs._1password.enable = true;
    services.thermald.enable = lib.mkIf (pkgs.system == "x86_64-linux") true;

    # services.eternal-terminal.enable = true;
    hardware.enableAllFirmware = true;
    hardware.enableRedistributableFirmware = true;
    # hardware.fancontrol.enable = true;

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
      sftp-ssh = "${pkgs.avahi}/etc/avahi/services/sftp-ssh.service";
      vnc = ''
        <?xml version="1.0" standalone='no'?>
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_rfb._tcp</type>
            <port>5901</port>
          </service>
        </service-group>
      '';
      smb = ''
        <?xml version="1.0" standalone='no'?>
         <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
         <service-group>
           <name replace-wildcards="yes">%h</name>
           <service>
             <type>_smb._tcp</type>
             <port>445</port>
           </service>
         </service-group>
      '';
    };
    services.udev = {enable = lib.mkDefault true;};

    programs.zsh = {
      enable = true;
    };

    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    };

    networking.extraHosts = ''
      192.168.0.15 ipa.harkema.io
    '';
    # system.nixos.tags = ["with-default"];
    services.ntp = {
      enable = true;
      servers = [
        "0.nl.pool.ntp.org"
        "1.nl.pool.ntp.org"
        "2.nl.pool.ntp.org"
        "3.nl.pool.ntp.org"
      ];
    };

    security.pki.certificateFiles = [./ca.crt];

    networking.enableIPv6 = false;

    security.ipa = {
      enable = true;
      server = "ipa.harkema.io";
      domain = "harkema.io";
      realm = "HARKEMA.IO";
      basedn = "dc=harkema,dc=io";
      certificate = pkgs.fetchurl {
        url = "https://ipa.harkema.io/ipa/config/ca.crt";
        sha256 = "0c69vkc45v9rga5x349l4znykcvgwngawx0axrhqq4jj3san7lb8";
      };
      dyndns.enable = true; # TODO: enable this??
    };
    # documentation.nixos.enable = false;
    programs.mtr.enable = true;

    services.rsyslogd = {
      enable = true;

      extraConfig = ''
        *.*    @@nix.harke.ma:5140;RSYSLOG_SyslogProtocol23Format
      '';
    };
    boot = {
      kernelParams = [
        "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
        "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
        "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
      ];
      loader = {
        systemd-boot = {
          netbootxyz.enable = true;
          configurationLimit = 10;
        };
      };
    };
  };
}
