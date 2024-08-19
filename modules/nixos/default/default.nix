{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom;
# let
#   theme = inputs.themes.custom (inputs.themes.catppuccin-mocha
#     // {
#       base00 = "000000";
#     });
# in
  {
    imports = ["${inputs.nixos-hardware}/common/gpu/24.05-compat.nix"];
    config = {
      # assertions = [
      #   (assertPackage pkgs "_389-ds-base")
      #   (assertPackage pkgs "freeipa")
      #   (assertPackage pkgs "sssd")
      # ];

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

      zramSwap = {
        enable = mkDefault true;
      };

      console = {
        earlySetup = true;
        # font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
        # packages = with pkgs; [terminus_font];
        keyMap = "us";
        # useXkbConfig = true; # use xkb.options in tty.
      };

      boot = {
        recovery.enable = mkDefault true;
        initrd = {
          systemd.emergencyAccess = "abcdefg";
          # includeDefaultModules = true;
        };

        crashDump.enable = true;

        hardwareScan = true;

        kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "kernel.sysrq" = 1;
        };

        tmp = {
          useTmpfs = mkDefault false;
          cleanOnBoot = mkDefault false;
        };

        # kernelPackages = lib.mkDefault pkgs.linuxPackages_6_7;
        kernelPackages =
          if (pkgs.stdenv.isAarch64 || config.trait.hardware.vm.enable)
          then mkDefault (pkgs.linuxPackagesFor pkgs.linuxPackages_latest_kernel_cached) # pkgs.linuxPackages_latest
          else mkDefault (pkgs.linuxPackagesFor pkgs.linuxPackages_cachyos_kernel_cached); # pkgs.linuxPackages_cachyos;

        kernelModules = ["wireguard"];

        supportedFilesystems = ["ntfs"];

        loader = {
          systemd-boot = {
            netbootxyz.enable = true;
            configurationLimit = 20;
          };
        };
      };

      nixpkgs.overlays = [
        (self: super: {
          linuxPackages_latest_kernel_cached = builtins.trace "KERNEL CCACHE LATEST" super.linuxPackages_latest.kernel.overrideAttrs {
            stdenv = builtins.trace "KERNEL CCACHE LATEST STDENV" self.ccacheStdenv;
          };
          linuxPackages_cachyos_kernel_cached = builtins.trace "KERNEL CCACHE CACHOS" super.linuxPackages_cachyos.kernel.overrideAttrs {
            stdenv = builtins.trace "KERNEL CCACHE CACHOS STDENV" self.ccacheStdenv;
          };
          linuxPackages_xanmod_stable_kernel_cached = builtins.trace "KERNEL CCACHE XANMOD" super.linuxPackages_xanmod_stable.kernel.overrideAttrs {
            stdenv = builtins.trace "KERNEL CCACHE XANMOD STDENV" self.ccacheStdenv;
          };
        })
      ];

      # environment.etc = {
      #   "current-system-packages".source = pkgs.custom.pkgs-index.override {
      #     packages = config.environment.systemPackages;
      #   };
      # };

      # environment.etc."current-system-packages.csv".text = let
      #   packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      #   sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
      #   formatted = builtins.concatStringsSep "\n" sortedUnique;
      # in
      #   formatted;

      environment = {
        sessionVariables.MOZ_ENABLE_WAYLAND = "0";

        systemPackages =
          (with pkgs; [
            meld
            _86Box-with-roms
            # dry
            # etcher
            # fancy-motd
            # mkchromecast
            # nix-switcher # : needs github auth
            # ntfy
            # rtop
            # udisks2
            git
            aide
            archivemount
            bandwhich
            bash
            bashmount
            bmon
            castnow
            catt
            chunkfs
            clex
            # compsize
            ctop
            curl
            devdash
            devtodo
            dfrs
            dirdiff
            discordo
            dosbox-x
            duc
            ethtool
            fam
            fcast-receiver
            fwupd
            fwupd-efi
            gdu
            git
            gnomecast
            go-chromecast
            googler
            hw-probe
            ifuse
            ipcalc
            iptraf-ng
            kexec-tools
            kmon
            lazydocker
            ldapdomaindump
            libnotify
            lm_sensors
            lorri
            lshw
            mbuffer
            ncdu
            nfs-utils
            nil
            nix-top
            nixd
            ntfs3g
            ntfy-sh
            nvchecker
            openldap
            pamix
            pamixer
            parallel-disk-usage
            pavucontrol
            pciutils
            ponymix
            pulsemixer
            pv
            silenthound
            smartmontools
            socat
            ssh-tools
            sshfs
            sshportal
            swapview
            systemctl-tui
            sysz
            tiptop
            tpm-tools
            treecat
            ttmkfdir
            ttop
            tydra
            udiskie
            netscanner
            usbutils
            usermount
            viddy
            wget
            wget
            wmctrl
            wtf
          ])
          ++ (with pkgs.custom; [
            ssh-proxy-agent
            menu
            pvzstd
            ssm
            tailscale-tui
            sshed
            # rmfuse
          ])
          ++ (optionals pkgs.stdenv.isx86_64 (with pkgs; [
            google-chrome
            netflix

            cmospwd
            uefisettings
            libsmbios

            dmidecode
            refind
          ]));
      };
      # services.ntfy-sh.enable = true;

      apps = {
        attic.enable = mkDefault true;
        ipa.enable = mkDefault true;
        atop.enable = mkDefault true;
      };

      proxy-services.enable = mkDefault true;

      systemd = {
        enableEmergencyMode = mkDefault false;

        #   services = {
        #     "numlockx" = {

        #       wants = [
        #         "multi-user.target"
        #         "network.target"
        #       ];
        #       after = [
        #         "multi-user.target"
        #         "network.target"
        #       ];

        #       script = ''
        #         ${pkgs.numlockx}/bin/numlockx on
        #       '';
        #       serviceConfig = {
        #         Type = "oneshot";
        #       };
        #     };
        #   };
      };

      services = {
        usbguard = {
          enable = true;
          dbus.enable = true;
          # ruleFile
          # package
          # restoreControllerDeviceState
          # presentDevicePolicy
          # presentControllerPolicy
          # insertedDevicePolicy
          # implicitPolicyTarget
          # deviceRulesWithPort
          IPCAllowedUsers = ["tomas" "root"];
          IPCAllowedGroups = ["tomas" "root" "plugdev"];
        };

        irqbalance.enable = true;

        rpcbind.enable = true;

        dbus = {
          enable = true;
          packages = with pkgs; [mpv];
        };

        # atd.enable = true;

        kmscon = {
          enable = mkDefault true;
          hwRender = true;
          fonts = [
            {
              name = "JetBrainsMono Nerd Font Mono";
              package = pkgs.nerdfonts;
            }
          ];
        };

        preload.enable = true;
        actkbd.enable = mkForce false;

        ananicy = {
          enable = true;
          package = pkgs.ananicy-cpp;
          rulesProvider = pkgs.ananicy-rules-cachyos;
        };

        fstrim.enable = true;

        throttled.enable = pkgs.stdenv.isx86_64;

        # cron.enable = true;

        zram-generator = {
          enable = true;
          settings = {
            zram0 = {
              # zram-size = "ram / 2";
              compression-algorithm = "zstd";
            };
          };
        };
        # earlyoom = {
        #   enable = true;
        #   enableNotifications = true;
        # };

        openvscode-server.enable = true;

        seatd.enable = true;

        # udisks2 = {
        #   enable = true;
        # };

        das_watchdog.enable = true;

        # check_mk_agent = {
        #   enable = true;
        #   bind = "0.0.0.0";
        #   openFirewall = true;
        #   package = pkgs.check_mk_agent.override {enablePluginSmart = true;};
        # };

        openssh = {
          enable = true;

          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = true;
            PermitRootLogin = "yes";
            AcceptEnv = "*";
            X11Forwarding = true;
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

      security = {
        # sudo.package = pkgs.sudo.override {withSssd = true;};
        audit.enable = true;
        auditd.enable = true;
      };

      programs = {
        fzf.fuzzyCompletion = true;

        dconf.enable = true;

        appimage = {
          enable = true;
          binfmt = true;
        };
        # darling.enable = pkgs.stdenv.isx86_64;

        flashrom.enable = true;

        # rust-motd = {
        #   enable = true;
        #   settings = {
        #     global = {
        #       progress_full_character = "=";
        #       progress_empty_character = "=";
        #       progress_prefix = "[";
        #       progress_suffix = "]";
        #       time_format = "%Y-%m-%d %H:%M:%S";
        #     };
        #     banner = {
        #       color = "red";
        #       command = "hostname | ${pkgs.figlet}/bin/figlet -f slant";
        #     };
        #     uptime = {
        #       prefix = "Up";
        #     };
        #     # weather = {
        #     #   url = "https://wttr.in/Amsterdam";
        #     # };
        #     service_status = {
        #       Accounts = "accounts-daemon";
        #       Attic-watch-store = "attic-watch-store";
        #     };
        #     filesystems = {
        #       root = "/";
        #     };
        #     memory = {
        #       swap_pos = "beside"; # or "below" or "none"
        #     };
        #     last_login = {
        #       tomas = 2;
        #     };
        #     last_run = {};
        #   };
        # };
        # git = {
        #   enable = true;
        #   lfs.enable = true;
        # };
        htop = {
          enable = true;
          package = pkgs.htop;
          settings = {
            show_program_path = false;
            hide_kernel_threads = true;
            hide_userland_threads = true;
          };
        };

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
