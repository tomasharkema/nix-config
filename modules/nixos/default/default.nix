{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
# let
#   theme = inputs.themes.custom (inputs.themes.catppuccin-mocha
#     // {
#       base00 = "000000";
#     });
# in
{
  # options = {
  #   variables = lib.mkOption {
  #     type = lib.types.attrs;
  #     default = {
  #       # theme = theme;
  #     };
  #   };
  # };

  config = with lib; {
    # Set your time zone.
    time.timeZone = "Europe/Amsterdam";

    # Select internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
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
    };

    virtualisation.spiceUSBRedirection.enable = true;
    services.fstrim.enable = true;
    zramSwap = {
      enable = true;
    };

    boot = {
      # hardwareScan = true;
      kernel.sysctl."net.ipv4.ip_forward" = 1;

      tmp = {
        useTmpfs = true;
        cleanOnBoot = true;
      };

      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      # kernelParams = [
      #   "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
      #   "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
      #   "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
      # ];
      loader = {
        systemd-boot = {
          # netbootxyz.enable = true;
          configurationLimit = 10;
        };
      };
    };

    environment.systemPackages =
      (with pkgs; [
        atop
        bitwarden-cli
        curl
        devtodo
        fwupd
        fwupd-efi
        hw-probe
        lm_sensors
        notify
        opencryptoki
        openldap
        pciutils
        pkgs.deepin.udisks2-qt5
        pv
        tpm-tools
        udisks2
        wget
        sshportal
      ])
      ++ (with pkgs.custom; [
        flashprog
        graylog-cli-dashboard
        menu
        pvzstd
      ])
      ++ (
        if pkgs.stdenv.isx86_64
        then
          with pkgs; [
            pkgs.custom.ztui
            # bitwarden
            bitwarden-menu
          ]
        else []
      );

    apps.attic.enable = mkDefault true;
    proxy-services.enable = mkDefault true;

    services = {
      packagekit.enable = true;
      cron.enable = true;

      zram-generator.enable = true;

      earlyoom = {
        enable = true;
      };

      vscode-server.enable = true;

      udisks2 = {
        enable = true;
      };

      das_watchdog.enable = true;

      thermald.enable = mkIf (pkgs.system == "x86_64-linux") true;

      clipmenu.enable = true;

      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "yes";
        };
      };

      mackerel-agent = {
        enable = true;
        apiKeyFile = config.age.secrets.mak.path;
      };

      fwupd.enable = true;

      avahi.extraServiceFiles = {
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

      udev = {enable = lib.mkDefault true;};

      ntp = {
        enable = true;
        servers = [
          "0.nl.pool.ntp.org"
          "1.nl.pool.ntp.org"
          "2.nl.pool.ntp.org"
          "3.nl.pool.ntp.org"
        ];
      };

      # rsyslogd = {
      #   enable = true;

      #   extraConfig = ''
      #     *.*    @@nix.harke.ma:5140;RSYSLOG_SyslogProtocol23Format
      #   '';
      # };
    };

    services.fluentd = {
      enable = true;

      config = ''
        # Match all patterns
        <match **>
          @type http

          endpoint https://oneuptime.com/fluentd/logs
          open_timeout 2

          headers {"x-oneuptime-service-token":"96c7bca0-d290-11ee-9b6a-55a2f9409bca"}

          content_type application/json
          json_array true

          <format>
            @type json
          </format>
          <buffer>
            flush_interval 10s
          </buffer>
        </match>
      '';
    };

    programs = {
      git = {
        enable = true;
        lfs.enable = true;
      };
      htop = {
        enable = true;
        settings = {
          show_program_path = false;
          hide_kernel_threads = true;
          hide_userland_threads = true;
        };
      };

      _1password.enable = true;
      ssh.startAgent = true;
      mosh.enable = true;
      nix-ld.enable = true;
      zsh.enable = true;
      mtr.enable = true;
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
      command-not-found.enable = false;
    };

    hardware = {
      enableAllFirmware = mkDefault true;
      enableRedistributableFirmware = mkDefault true;
      # fancontrol.enable = true;
    };

    systemd = {
      targets = {
        sleep.enable = mkDefault false;
        suspend.enable = mkDefault false;
        hibernate.enable = mkDefault false;
        hybrid-sleep.enable = mkDefault false;
      };
      services = {
        NetworkManager-wait-online.enable = lib.mkForce false;
        #     systemd-networkd-wait-online.enable = lib.mkForce false;
      };
    };

    networking = {
      firewall = {
        enable = mkDefault true;
      };
      networkmanager.enable = true;
      enableIPv6 = false;
    };

    # powerManagement.powertop.enable = mkDefault true;
    # programs.gnupg.agent.enable = true;
  };
}
