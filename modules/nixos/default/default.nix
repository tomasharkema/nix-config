{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  sbctl-tpm = pkgs.writeShellScriptBin "sbctl-tpm" ''
    sudo sbctl rotate-keys --pk-keytype tpm --kek-keytype kek --db-keytype file
  '';
in {
  config = {
    assertions = [
      # {
      #   assertion = (builtins.length config.boot.kernelPatches) == 0;
      #   message = "Kernelpatches require recompilation :(";
      # }

      #   (assertPackage pkgs "_389-ds-base")
      #   (assertPackage pkgs "freeipa")
      #   (assertPackage pkgs "sssd")
    ];

    age.secrets = {
      cachix-key = {
        rekeyFile = ./cachix-key.age;
      };
    };

    system = {
      build = {
        # self = inputs.self;
      };
      #      etc.overlay.enable = config.boot.initrd.systemd.enable;
      nixos.tags = ["${config.boot.kernelPackages.kernel.modDirVersion}"];
      rebuild.enableNg = true;
    };

    security.isolate.enable = true;

    systemd = {
      additionalUpstreamSystemUnits = ["systemd-bsod.service"];
      services = {
        "prepare-kexec".wantedBy = lib.mkIf pkgs.stdenv.isx86_64 ["multi-user.target"];
        NetworkManager-wait-online.enable = lib.mkForce false;
        systemd-networkd-wait-online.enable = lib.mkForce false;
      };

      watchdog = {
        rebootTime = "5m";
        # device = "/dev/watchdog";
        runtimeTime = "1m";
        kexecTime = "5m";
      };
    };

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

    # zramSwap = {
    #   enable = lib.mkDefault true;
    # };

    console = {
      earlySetup = true;
      # font = "ter-v32n";
      # packages = with pkgs; [terminus_font];
      keyMap = "us";
    };

    boot = {
      recovery = {
        enable = lib.mkDefault true;
        extraConfigurations = [
          #   ({...}: {
          #     imports = [
          ../../../installer/installer.nix
          #     ];
          #   })
        ];
      };

      crashDump.enable = pkgs.stdenv.isx86_64; # true;

      initrd = {
        compressor = "zstd";
        compressorArgs = ["-19"];
        # systemd.emergencyAccess = "abcdefg";
        includeDefaultModules = true;
        # unl0kr = {enable = config.disks.btrfs.encrypt;};
      };

      hardwareScan = true;

      extraModulePackages = lib.mkIf pkgs.stdenv.isx86_64 [
        config.boot.kernelPackages.cryptodev
        config.boot.kernelPackages.acpi_call
        config.boot.kernelPackages.fanout
      ];

      kernelParams = [
        "zswap.enabled=1"
        "efi_pstore.pstore_disable=0"
        "printk.always_kmsg_dump"
        "crash_kexec_post_notifiers"

        # "netconsole=@/,@192.168.0.100/"
      ];

      # kernel.sysctl = {
      #   "net.ipv4.ip_forward" = lib.mkDefault 1;
      #   "vm.swappiness" = lib.mkDefault 180;
      #   "vm.watermark_boost_factor" = lib.mkDefault 0;
      #   "vm.watermark_scale_factor" = lib.mkDefault 125;
      #   "vm.page-cluster" = lib.mkDefault 0;
      #   "vm.overcommit_memory" = lib.mkDefault "1";
      #   # "kernel.printk" = "8 4 1 7";
      # };

      tmp = {
        useTmpfs = lib.mkDefault true;
        cleanOnBoot = lib.mkDefault true;
      };

      kernelPackages =
        if (pkgs.stdenv.isAarch64 || config.traits.hardware.vm.enable)
        then lib.mkDefault pkgs.linuxPackages_latest
        else
          (
            if config.traits.server.enable
            then lib.mkDefault pkgs.linuxPackages_cachyos-server
            else lib.mkDefault pkgs.linuxPackages_cachyos
          );

      kernelModules = [
        # "wireguard"
        # "netconsole"
        # "apfs"
      ];

      supportedFilesystems = [
        "ntfs"
        # "apfs"
        "nfs"
      ];
      initrd.kernelModules = [
        # "netconsole"
      ];
      loader = {
        systemd-boot = {
          netbootxyz.enable = true;
          configurationLimit = 10;
        };
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

      variables.NH_FLAKE = "/home/tomas/Developer/nix-config";

      enableAllTerminfo = true;
      systemPackages =
        (with pkgs; [
          (lib.mkIf pkgs.stdenv.isx86_64 ipmicfg)
          uv
          custom.discovery-rs
          nixos-rebuild-ng
          lnav

          termshark
          tshark
          python3Packages.pip
          config.boot.kernelPackages.iio-utils
          cutecom
          sbctl-tpm
          urjtag
          redfishtool
          sigrok-cli
          custom.partclone-utils
          bridge-utils
          ipmitool
          openipmi
          freeipmi
          ipmiutil
          xterm
          libheif
          gensio
          ser2net
          # lz4
          p7zip
          starship
          helix
          regname
          nyaa
          hextazy
          tran
          tparted
          play
          zathura
          piratebay
          mpv
          imv
          rsbkb
          gpsd
          mpremote
          nix-search-cli
          custom.zide
          custom.wikiman
          custom.glide
          binwalk
          bat-extras.batman
          bat-extras.batdiff
          bat-extras.batwatch
          bat-extras.batpipe
          bat-extras.batgrep
          compsize
          # dry
          libgpiod
          # gpio-utils
          # fam # unmaintained
          fancy-motd
          # mkchromecast
          # nix-switcher # : needs github auth
          # ntfy
          testdisk # useful for repairing boot problems
          ms-sys # for writing Microsoft boot sectors / MBRs
          efibootmgr
          efivar
          parted
          gptfdisk
          ddrescue
          ccrypt
          cryptsetup # needed for dm-crypt volumes
          python313Packages.pyftdi
          libftdi
          libftdi1
          # Some text editors.
          vim

          # Some networking tools.
          fuse
          fuse3
          sshfs-fuse
          socat
          screen
          tcpdump
          bmc-tools
          # Hardware-related tools.
          sdparm
          hdparm
          smartmontools # for diagnosing hard disks
          pciutils
          usbutils
          nvme-cli

          # Some compression/archiver tools.
          unzip
          zip
          onionshare
          # oterm
          rtop
          # socklog
          # tailspin
          tsui
          ttop
          agenix-rekey
          aide
          # apfs-fuse
          # apfsprogs
          openseachest
          opensoundmeter

          archivemount
          bandwhich
          bash
          bashmount
          bmon
          castnow
          catt
          chunkfs
          cksfv
          clex
          colorized-logs
          ctop
          curl
          devcontainer
          xxd
          devtodo
          dfrs
          distrobox
          distrobox-tui
          duc
          ethtool
          fcast-receiver
          gdu
          git
          git
          glog
          glogg

          ghostty
          htmlq
          hueadm
          hw-probe
          ifuse
          ipcalc
          iptraf-ng
          usbredir
          whatfiles
          # jupyter
          kexec-tools
          kmon
          lazydocker
          # ldapdomaindump
          libnotify
          lm_sensors
          lorri
          lrzsz
          lshw
          mbuffer
          minio-client
          ncdu
          nethogs
          netop
          netproc
          netscanner
          nfs-utils
          nil
          nix-btm
          nix-top
          nixd
          nixos-facter
          ntfs3g
          ntfy-sh
          nvchecker
          openldap
          pamix
          pamixer
          nix-playground
          nix-check-deps
          gnupg
          pciutils
          pigz
          pkgs.custom.nix-helpers
          ponymix
          pulsemixer
          pv
          s-tui
          silenthound
          smartmontools
          socat
          websocat
          ser2net
          wol
          picotool
          openocd
          cmake
          ninja
          gnumake
          gdb
          gdbgui
          clang-tools
          i2c-tools

          squashfsTools
          squashfs-tools-ng
          ssh-import-id
          ssh-tools
          sshfs
          sshportal
          strace
          swapview
          systemctl-tui
          # systeroid
          sysz
          tcptrack
          nmap
          tiptop
          tio
          tpm-tools
          treecat
          networkmanagerapplet
          ttmkfdir
          tydra
          update-nix-fetchgit
          updatecli
          usbutils
          usermount
          viddy
          watchlog
          wavemon
          wget
          wget
          wmctrl
          wtfutil
          zstd
          # isd
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
            meshtastic-fix
            spectre-meltdown-checker
            gnutls
            cmospwd
            uefisettings
            libsmbios
            micropython
            dmidecode
            refind
            fwupd
            fwupd-efi
          ]
        ));
    };

    systemd.tmpfiles = {
      packages = [pkgs.abrt];

      # se
    };

    apps = {
      attic.enable = lib.mkDefault true;
      ipa.enable = lib.mkDefault true;
      atop.enable = lib.mkDefault true;
    };

    users.groups.ftdi = {
      members = ["root" "tomas"];
    };

    # proxy-services.enable = lib.mkDefault true;

    services = {
      languagetool.enable = true;

      scx = {
        enable = pkgs.stdenvNoCC.isx86_64;
        #package = pkgs.scx_git.full;
        scheduler = "scx_lavd"; # "scx_bpfland";
      };
      # geoipupdate.enable = true;
      earlyoom.enableNotifications = true;
      # locate.enable = true;

      uptimed.enable = true;
      tuptime.enable = true;

      # uptime.enableSeparateMonitoringService = true;

      # snmpd = {
      #   enable = true;
      #   configText = ''
      #     rocommunity   public
      #     trapsink      localhost:162 public
      #   '';
      # };

      smartd = {
        enable = true;
        notifications = {
          wall.enable = true;
          systembus-notify.enable = true;
        };
      };

      watchdogd = {
        enable = true;
      };

      # sysstat.enable = lib.mkDefault true;
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

      # atd = {
      #   enable = true;
      #   allowEveryone = true;
      # };

      kmscon = {
        # enable = lib.mkDefault true;
        hwRender = true;
        useXkbConfig = true;

        fonts = [
          {
            name = "JetBrainsMono Nerd Font Mono";
            package = pkgs.nerd-fonts.jetbrains-mono;
          }
        ];
      };

      preload.enable = true;

      # actkbd.enable = lib.mkForce false;

      ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
        extraRules = [
          {
            name = "nom";
            type = "compiler";
          }
          {
            name = "nix";
            type = "compiler";
          }
          {
            name = "nix-daemon";
            type = "compiler";
          }
          {
            name = "nh";
            type = "compiler";
          }
        ];
      };

      fstrim.enable = true;

      throttled.enable = pkgs.stdenv.isx86_64;

      # cron.enable = true;

      # zram-generator = {
      #   enable = lib.mkDefault true;
      #   settings = {
      #     zram0 = {
      #       # zram-size = "ram / 2";
      #       compression-algorithm = "zstd";
      #     };
      #   };
      # };
      # earlyoom = {
      #   enable = true;
      #   enableNotifications = true;
      # };

      seatd.enable = true;

      udisks2 = {
        enable = true;
      };

      # das_watchdog.enable = true;

      openssh = {
        enable = true;
        permitRootLogin = lib.mkForce "no";
        passwordAuthentication = false;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = lib.mkForce "no";

          # PasswordAuthentication = false;
          # KbdInteractiveAuthentication = true;
          # AcceptEnv = "*";
        };
      };

      fwupd.enable = lib.mkDefault true;

      avahi = {
        enable = true;
        # allowInterfaces = ["tailscale0"];
        ipv6 = false;
        publish.enable = true;
        publish.userServices = true;
        publish.addresses = true;
        publish.domain = true;
        publish.hinfo = true;
        nssmdns4 = true;
        publish.workstation = true;
        openFirewall = true;
        # reflector = true;

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

      udev = {
        enable = lib.mkDefault true;
        packages = with pkgs; [picoprobe-udev-rules];

        extraRules = ''
          ACTION=="add", SUBSYSTEM=="usb", \
            ATTR{idVendor}=="1d50", ATTR{idProduct}=="6170", \
            RUN+="${pkgs.kmod}/bin/modprobe -b dln2"

          ACTION=="add", SUBSYSTEM=="drivers", ENV{DEVPATH}=="/bus/usb/drivers/dln2", \
            ATTR{new_id}="1d50 6170 ff"


          SUBSYSTEMS=="usb", ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0753", MODE:="0666"
          KERNEL=="ttyACM*", ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0753", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
        '';
      };

      chrony = {
        enable = true;

        servers = [
          #"timepi.local"
          #"time.cloudflare.com"
        ];

        extraConfig = ''
          makestep 1.1 100
          server timepi.local iburst minpoll 1 maxpoll 2

          pool  nl.pool.ntp.org           iburst  minpoll 4  maxpoll 4
          #pool  europe.pool.ntp.org    iburst  minpoll 4  maxpoll 4
          #pool  de.pool.ntp.org        iburst  minpoll 4  maxpoll 4

          server  ntp0.nl.uu.net  iburst  minpoll 4  maxpoll 4
          server  ntp1.nl.uu.net  iburst  minpoll 4  maxpoll 4
          server  ntp1.time.nl    iburst  minpoll 4  maxpoll 4

        '';
      };

      ntp = {
        enable = lib.mkForce false; # true;
        servers = [
          "0.nl.pool.ntp.org"
          "1.nl.pool.ntp.org"
          "2.nl.pool.ntp.org"
          "3.nl.pool.ntp.org"
        ];
      };
    };

    security = {
      audit.enable = true;
      auditd.enable = true;
      pam.sshAgentAuth.enable = true;
      wrappers.nethoscope = {
        owner = "tomas";
        group = "tomas";
      };
      # sudo.enable = false;
      # sudo-rs.enable = true;
    };

    programs = {
      fzf.fuzzyCompletion = true;
      #`mosh.enable = true;
      dconf.enable = true;
      sharing.enable = true;
      # darling.enable = pkgs.stdenv.isx86_64;
      autojump.enable = true;
      bandwhich.enable = true;
      cpu-energy-meter.enable = pkgs.stdenv.isx86_64;
      flashrom.enable = true;
      flashprog.enable = true;
      git-worktree-switcher.enable = true;
      iftop.enable = true;
      localsend = {
        enable = true;
        openFirewall = true;
      };
      wireshark = {
        enable = true;
        dumpcap.enable = true;
        usbmon.enable = true;
        package = pkgs.wireshark;
      };
      nix-index = {
        enable = true;
        enableZshIntegration = true;
      };
      nethoscope.enable = true;
      git = {
        enable = true;
        lfs.enable = true;
      };
      udevil.enable = true;
      # usbtop.enable = true;
      wavemon.enable = true;
      trippy.enable = true;
      ydotool.enable = true;

      system-config-printer.enable = true;
      # corefreq.enable = pkgs.stdenv.isx86_64;

      htop = {
        enable = true;
        package = pkgs.htop;
        settings = {
          show_program_path = false;
          hide_xkernel_threads = true;
          hide_userland_threads = true;
          screen_tabs = true;
        };
      };

      ssh = {
        # startAgent = true;
        # forwardX11 = true;
        # extraConfig = ''
        #  ForwardAgent yes
        # '';
      };

      nix-ld.enable = true;
      zsh = {
        enable = true;
        vteIntegration = true;
      };
      mtr.enable = true;
      command-not-found.enable = false;
    };

    hardware = {
      enableAllFirmware = lib.mkDefault true;
      enableRedistributableFirmware = lib.mkDefault true;
      # fancontrol.enable = true;
      sensor.hddtemp = {
        enable = true;
        drives = ["/dev/disk/by-path/*"];
      };
      libftdi.enable = true;
      mcelog.enable = true;
    };

    networking = {
      firewall = {
        enable = lib.mkDefault true;
      };

      networkmanager = {
        enable = lib.mkDefault true;
        wifi.scanRandMacAddress = lib.mkDefault true;
      };

      # timeServers = ["192.168.9.49"];

      useNetworkd = lib.mkIf config.networking.networkmanager.enable false;
    };

    # powerManagement.powertop.enable = lib.mkDefault true;
    # programs.gnupg.agent.enable = true;
  };
}
