{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  config = {
    assertions = [
      {
        assertion = (builtins.length config.boot.kernelPatches) == 0;
        message = "Kernelpatches require recompilation :(";
      }

      #   (assertPackage pkgs "_389-ds-base")
      #   (assertPackage pkgs "freeipa")
      #   (assertPackage pkgs "sssd")
    ];

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

    system = {
      switch = {
        enable = false;
        enableNg = true;
      };
    };

    virtualisation.spiceUSBRedirection.enable = true;

    zramSwap = {
      enable = lib.mkDefault true;
    };

    console = {
      earlySetup = true;
      font = "ter-v32n";
      packages = with pkgs; [terminus_font];
      keyMap = "us";
    };

    boot = {
      recovery.enable = lib.mkDefault true;
      initrd = {
        # systemd.emergencyAccess = "abcdefg";
        includeDefaultModules = true;
      };

      hardwareScan = true;

      kernelParams = ["preempt=full"];

      kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "vm.overcommit_memory" = 1;
      };

      tmp = {
        useTmpfs = lib.mkDefault true;
        cleanOnBoot = lib.mkDefault true;
      };

      kernelPackages = let
      in
        if (pkgs.stdenv.isAarch64 || config.traits.hardware.vm.enable)
        then lib.mkDefault pkgs.linuxPackages_latest
        else
          (
            if config.traits.server.enable
            then lib.mkDefault pkgs.linuxPackages_cachyos-server
            else lib.mkDefault pkgs.linuxPackages_cachyos
          ); # (pkgs.linuxPackagesFor pkgs.linux_cachyos);

      kernelModules = ["wireguard"];

      supportedFilesystems = ["ntfs"];

      loader = {
        systemd-boot = {
          netbootxyz.enable = true;
          configurationLimit = 20;
        };
      };
    };

    chaotic = {
      scx = {
        enable = !(config.traits.server.enable) && pkgs.stdenvNoCC.isx86_64;
        scheduler = "scx_bpfland";
        package = pkgs.scx.full;
      };
    };

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
      # memoryAllocator = {
      #   provider = "graphene-hardened";
      # };

      pathsToLink = [
        "/share/zsh"
        "/share/xdg-desktop-portal"
        "/share/applications"
        "/share/fonts"
        "/share/icons"
      ];

      # sessionVariables.MOZ_ENABLE_WAYLAND = "0";
      enableAllTerminfo = true;
      systemPackages =
        (with pkgs; [
          ssh-import-id
          tcptrack
          netproc
          netop
          nethogs
          wavemon
          strace
          lrzsz
          nix-btm
          update-nix-fetchgit
          updatecli
          devcontainer
          # tailspin
          colorized-logs
          glog
          glogg
          socklog
          watchlog
          tsui
          agenix-rekey
          distrobox
          distrobox-tui
          custom.ztui
          s-tui
          # dry
          # etcher
          # fancy-motd
          # mkchromecast
          # nix-switcher # : needs github auth
          # ntfy
          # rtop
          onionshare
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
          # oterm
          ssh-import-id
          duc
          ethtool
          # fam # unmaintained
          fcast-receiver
          fwupd
          fwupd-efi
          gdu
          git
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
          # ttop
          tydra
          udiskie
          netscanner
          usbutils
          usermount
          viddy
          wget
          hueadm
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
        ++ (lib.optionals pkgs.stdenv.isx86_64 (
          with pkgs; [
            gnutls
            cmospwd
            uefisettings
            libsmbios

            dmidecode
            refind
          ]
        ));
    };

    apps = {
      attic.enable = lib.mkDefault true;
      ipa.enable = lib.mkDefault true;
      atop.enable = lib.mkDefault true;
    };

    proxy-services.enable = lib.mkDefault true;

    systemd = {
      enableEmergencyMode = lib.mkDefault false;
    };

    services = {
      sysstat.enable = lib.mkDefault true;
      irqbalance.enable = true;
      # aria2.enable = true;
      rpcbind.enable = true;
      cachefilesd.enable = true;

      acpid = {
        enable = true;
        logEvents = true;
      };

      dbus = {
        enable = true;
        # packages = with pkgs; [mpv];
      };

      # atd.enable = true;

      kmscon = {
        enable = lib.mkDefault true;
        hwRender = true;
        fonts = [
          {
            name = "JetBrainsMono Nerd Font Mono";
            package = pkgs.nerdfonts;
          }
        ];
      };

      preload.enable = true;

      actkbd.enable = lib.mkForce false;

      ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };

      fstrim.enable = true;

      throttled.enable = pkgs.stdenv.isx86_64;

      # cron.enable = true;

      zram-generator = {
        enable = lib.mkDefault true;
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
        passwordAuthentication = false;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";

          # PasswordAuthentication = false;
          # KbdInteractiveAuthentication = true;
          # AcceptEnv = "*";
        };
      };

      fwupd.enable = lib.mkDefault true;

      avahi = {
        enable = true;
        package = pkgs.avahi.override (old: {
          gtk3Support = true;
          # qt5Support = true;
          # withPython = true;
        });

        extraServiceFiles = {
          ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
          sftp-ssh = "${pkgs.avahi}/etc/avahi/services/sftp-ssh.service";
          nfs = ''
            <?xml version="1.0" standalone='no'?>
            <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
            <service-group>
              <name replace-wildcards="yes">home %h</name>
              <service>
                <type>_nfs._tcp</type>
                <port>2049</port>
                <txt-record>path=/home/tomas</txt-record>
              </service>
            </service-group>
          '';

          # vnc = ''
          #   <?xml version="1.0" standalone='no'?>
          #   <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
          #   <service-group>
          #     <name replace-wildcards="yes">%h</name>
          #     <service>
          #       <type>_rfb._tcp</type>
          #       <port>5900</port>
          #     </service>
          #   </service-group>
          # '';
          # smb = ''
          #   <?xml version="1.0" standalone='no'?>
          #    <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
          #    <service-group>
          #      <name replace-wildcards="yes">%h</name>
          #      <service>
          #        <type>_smb._tcp</type>
          #        <port>445</port>
          #      </service>
          #    </service-group>
          # '';
          # rdp = ''
          #   <?xml version="1.0" standalone='no'?>
          #    <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
          #    <service-group>
          #      <name replace-wildcards="yes">%h</name>
          #      <service>
          #        <type>_rdp._tcp</type>
          #        <port>${toString config.services.xrdp.port}</port>
          #      </service>
          #    </service-group>
          # '';
        };
      };

      udev.enable = lib.mkDefault true;

      chrony = {
        enable = true;
        enableNTS = true;
      };
      ntp = {
        enable = lib.mkForce false;
        #   enable = true;
        #   servers = [
        #     "0.nl.pool.ntp.org"
        #     "1.nl.pool.ntp.org"
        #     "2.nl.pool.ntp.org"
        #     "3.nl.pool.ntp.org"
        #   ];
      };
    };

    security = {
      audit.enable = true;
      auditd.enable = true;
      pam.sshAgentAuth.enable = true;
    };

    programs = {
      fzf.fuzzyCompletion = true;

      dconf.enable = true;

      # darling.enable = pkgs.stdenv.isx86_64;

      flashrom.enable = true;

      git = {
        enable = true;
        lfs.enable = true;
      };
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
        # forwardX11 = true;
        extraConfig = ''
          ForwardAgent yes

        '';
      };
      # mosh.enable = true;
      nix-ld.enable = true;
      zsh = {
        enable = true;
        vteIntegration = true;
      };
      mtr.enable = true;
      command-not-found.enable = false;

      ccache = {
        enable = true;
        packageNames = [
          "sssd"
          "freeipa"
          # "mutter"
          # "gnome-shell"
          # "gnome-session"
        ];
      };
    };

    nix.settings = {
      extra-sandbox-paths = [config.programs.ccache.cacheDir];
    };

    hardware = {
      enableAllFirmware = lib.mkDefault true;
      enableRedistributableFirmware = lib.mkDefault true;
      # fancontrol.enable = true;
    };

    # systemd = {
    # targets = {
    #   sleep.enable = lib.mkDefault false;
    #   suspend.enable = lib.mkDefault false;
    #   hibernate.enable = lib.mkDefault false;
    #   hybrid-sleep.enable = lib.mkDefault false;
    # };
    # services = {
    # NetworkManager-wait-online.enable = lib.mkForce false;
    #     systemd-networkd-wait-online.enable = lib.mkForce false;
    # };
    # };

    networking = {
      firewall = {
        enable = lib.mkDefault true;
      };

      networkmanager.enable = lib.mkDefault true;
      timeServers = ["time.cloudflare.com"];
    };

    # powerManagement.powertop.enable = lib.mkDefault true;
    # programs.gnupg.agent.enable = true;
  };
}
