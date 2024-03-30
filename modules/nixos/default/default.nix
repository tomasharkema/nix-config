{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
# let
#   theme = inputs.themes.custom (inputs.themes.catppuccin-mocha
#     // {
#       base00 = "000000";
#     });
# in
  {
    options = {
      installed = mkEnableOption "installed";

      #   variables = lib.mkOption {
      #     type = lib.types.attrs;
      #     default = {
      #       # theme = theme;
      #     };
      #   };
    };

    config = with lib; {
      # Set your time zone.
      time.timeZone = "Europe/Amsterdam";

      nix.package = pkgs.nixUnstable;

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

      zramSwap = {
        enable = mkDefault true;
      };

      console = {
        earlySetup = true;
        #   font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
        packages = with pkgs; [terminus_font];
        #   #    keyMap = "us";
        useXkbConfig = true; # use xkb.options in tty.
      };

      boot = {
        hardwareScan = true;
        kernel.sysctl."net.ipv4.ip_forward" = 1;

        # tmp = mkDefault {
        #   useTmpfs = true;
        #   cleanOnBoot = true;
        # };

        # kernelPackages = lib.mkDefault pkgs.linuxPackages_6_7;
        kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

        # kernelParams = [
        #   "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
        #   "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
        #   "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
        # ];

        loader = {
          systemd-boot = {
            netbootxyz.enable = true;
            configurationLimit = 20;
          };
        };
      };

      # programs.atop = {
      #   enable = true;
      #   netatop.enable = true;
      # };

      programs.atop = {
        atopRotateTimer.enable = true;
        enable = true;
        setuidWrapper.enable = true;
        atopService.enable = true;
        atopacctService.enable = true;
        atopgpu.enable = config.traits.hardware.nvidia.enable;
        netatop.enable = true;
      };

      environment.systemPackages =
        (with pkgs; [
          fancy-motd
          # dry
          # pkgs.deepin.udisks2-qt5
          # udisks2
          lshw
          usbutils
          ttop
          git
          wget
          curl
          sysz
          iptraf-ng
          netscanner
          bandwhich
          bashmount
          bmon
          compsize
          ctop
          curl
          devtodo
          devdash
          wtf
          fwupd
          fwupd-efi
          hw-probe
          kmon
          lazydocker
          lm_sensors
          ncdu
          nfs-utils
          notify
          openldap
          pciutils
          pv
          sshportal
          systemctl-tui
          tiptop
          tpm-tools
          udiskie
          usermount
          viddy
          wget
          zellij
          nix-top
        ])
        ++ (with pkgs.custom; [
          menu
          netbrowse
          podman-tui
          pvzstd
          ssm
          tailscale-tui
          sshed
        ])
        ++ (
          if pkgs.stdenv.isx86_64
          then [
            pkgs.custom.ztui
          ]
          else []
        );
      # services.ntfy-sh.enable = true;

      apps = {
        attic.enable = mkDefault true;
        ipa.enable = mkDefault true;
      };

      proxy-services.enable = mkDefault true;

      systemd = {
        enableEmergencyMode = false;
        watchdog = {
          device = "/dev/watchdog";
          runtimeTime = "10m";
          kexecTime = "10m";
          rebootTime = "10m";
        };

        user.services.auto-fix-vscode-server = {
          enable = true;
          wants = ["multi-user.target" "network.target"];
          after = ["multi-user.target" "network.target"];
        };
      };

      services = {
        kmscon = {
          enable = true;
          hwRender = config.traits.hardware.nvidia.enable;
          fonts = [
            {
              name = "JetBrainsMono Nerd Font Mono";
              package = pkgs.nerdfonts.override {
                fonts = ["JetBrainsMono"];
              };
            }
          ];
        };

        fstrim.enable = true;

        throttled.enable = pkgs.stdenv.isx86_64;

        cron.enable = true;

        zram-generator.enable = true;

        earlyoom = {
          enable = true;
          enableNotifications = true;
        };

        vscode-server.enable = true;

        # seatd.enable = true;

        udisks2 = {
          enable = true;
        };

        das_watchdog.enable = true;

        thermald.enable = mkIf (pkgs.system == "x86_64-linux") true;

        openssh = {
          enable = true;

          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = true;
            PermitRootLogin = "yes";
            # X11Forwarding = true;
          };
        };

        mackerel-agent = {
          enable = true;
          apiKeyFile = config.age.secrets.mak.path;
        };

        fwupd.enable = mkDefault true;

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
                <port>5900</port>
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
          rdp = ''
            <?xml version="1.0" standalone='no'?>
             <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
             <service-group>
               <name replace-wildcards="yes">%h</name>
               <service>
                 <type>_rdp._tcp</type>
                 <port>${toString config.services.xrdp.port}</port>
               </service>
             </service-group>
          '';
        };

        udev.enable = mkDefault true;

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

        # fluentd = {
        #   enable = true;

        #   config = ''
        #     # Match all patterns
        #     <match **>
        #       @type http

        #       endpoint https://oneuptime.com/fluentd/logs
        #       open_timeout 2

        #       headers {"x-oneuptime-service-token":"96c7bca0-d290-11ee-9b6a-55a2f9409bca"}

        #       content_type application/json
        #       json_array true

        #       <format>
        #         @type json
        #       </format>
        #       <buffer>
        #         flush_interval 10s
        #       </buffer>
        #     </match>
        #   '';
        # };
      };

      programs = {
        flashrom.enable = true;
        rust-motd = {
          enable = true;
          settings = {
            global = {
              progress_full_character = "=";
              progress_empty_character = "=";
              progress_prefix = "[";
              progress_suffix = "]";
              time_format = "%Y-%m-%d %H:%M:%S";
            };
            banner = {
              color = "red";
              command = "hostname | ${pkgs.figlet}/bin/figlet -f slant";
            };
            uptime = {
              prefix = "Up";
            };
            weather = {
              url = "https://wttr.in/Amsterdam";
            };
            service_status = {
              Accounts = "accounts-daemon";
              Cron = "cron";
            };
            filesystems = {
              root = "/";
            };
            memory = {
              swap_pos = "beside"; # or "below" or "none"
            };
            last_login = {tomas = 2;};
            last_run = {};
          };
          # [global]
          # progress_full_character = "="
          # progress_empty_character = "="
          # progress_prefix = "["
          # progress_suffix = "]"
          # time_format = "%Y-%m-%d %H:%M:%S"

          # [banner]
          # color = "red"
          # command = "hostname | figlet -f slant"
          # if you don't want a dependency on figlet, you can generate your
          # banner however you want, put it in a file, and then use something like:
          # command = "cat banner.txt"

          # [weather]
          # url = "https://wttr.in/New+York,New+York?0"
          # user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36"
          # proxy = "http://proxy:8080"

          # [service_status]
          # Accounts = "accounts-daemon"
          # Cron = "cron"

          # [docker]
          # Local containers MUST start with a slash
          # https://github.com/moby/moby/issues/6705
          # "/nextcloud-nextcloud-1" = "Nextcloud"
          # "/nextcloud-nextcloud-mariadb-1" = "Nextcloud Database"

          # [uptime]
          # prefix = "Up"

          # [user_service_status]
          # gpg-agent = "gpg-agent"

          # [ssl_certificates]
          # sort_method = "manual"
          #
          #    [ssl_certificates.certs]
          #    CertName1 = "/path/to/cert1.pem"
          #    CertName2 = "/path/to/cert2.pem"

          # [filesystems]
          # root = "/"

          # [memory]
          # swap_pos = "beside" # or "below" or "none"

          # [fail_2_ban]
          # jails = ["sshd", "anotherjail"]

          # [last_login]
          # sally = 2
          # jimmy = 1

          # [last_run]
        };
        # git = {
        #   enable = true;
        #   lfs.enable = true;
        # };
        htop = {
          enable = true;
          settings = {
            show_program_path = false;
            hide_kernel_threads = true;
            hide_userland_threads = true;
          };
        };

        _1password.enable = true;

        ssh = {
          # startAgent = true;
          forwardX11 = true;
          extraConfig = ''
            ForwardAgent yes
          '';
        };
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

      # systemd = {
      # targets = {
      #   sleep.enable = mkDefault false;
      #   suspend.enable = mkDefault false;
      #   hibernate.enable = mkDefault false;
      #   hybrid-sleep.enable = mkDefault false;
      # };
      # services = {
      # NetworkManager-wait-online.enable = lib.mkForce false;
      #     systemd-networkd-wait-online.enable = lib.mkForce false;
      # };
      # };

      networking = {
        firewall = {
          enable = mkDefault true;
        };

        networkmanager.enable = mkDefault true;
      };

      # powerManagement.powertop.enable = mkDefault true;
      # programs.gnupg.agent.enable = true;
    };
  }
