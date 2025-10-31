{
  config,
  pkgs,
  lib,
  ...
}: let
  # sbctl-tpm = pkgs.writeShellScriptBin "sbctl-tpm" ''
  #   sudo sbctl rotate-keys --pk-keytype tpm --kek-keytype kek --db-keytype file
  # '';
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
        # "prepare-kexec".wantedBy = lib.mkIf pkgs.stdenv.isx86_64 ["multi-user.target"];
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
      # earlySetup = true;
      # font = "ter-v32n";
      # packages = with pkgs; [terminus_font];
      # keyMap = "us";
      useXkbConfig = true;
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
        # dm = "zstd";
        # compressorArgs = ["-19"];
        # systemd.emergencyAccess = "abcdefg";
        includeDefaultModules = true;
        # unl0kr = {enable = config.disks.btrfs.encrypt;};
      };

      # hardwareScan = true;

      # extraModulePackages = lib.mkIf pkgs.stdenv.isx86_64 [
      #   config.boot.kernelPackages.cryptodev
      #   config.boot.kernelPackages.acpi_call
      #   config.boot.kernelPackages.fanout
      # ];

      kernelParams = [
        "zswap.enabled=1"
        # "efi_pstore.pstore_disable=0"
        # "printk.always_kmsg_dump"
        # "crash_kexec_post_notifiers"

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
            else lib.mkDefault pkgs.linuxPackages_cachyos-gcc
          );

      kernelModules = [
        # "wireguard"
        # "netconsole"
        # "apfs"
        "efi_pstore"
        "pstore"
      ];

      supportedFilesystems = [
        "ntfs"
        # "apfs"
        "nfs"
      ];
      initrd.kernelModules = [
        "efi_pstore"
        "pstore"
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

      homeBinInPath = true;

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
    };

    systemd.tmpfiles = {
      packages = [pkgs.abrt];

      # se
    };

    apps = {
      ipa.enable = lib.mkDefault true;
      atop.enable = lib.mkDefault true;
    };

    users.groups.ftdi = {
      members = ["root" "tomas"];
    };

    # proxy-services.enable = lib.mkDefault true;

    services = {
      languagetool.enable = true;

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
      fanout.enable = true;

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
          # KexAlgorithms = [
          #   "sntrup761x25519-sha512"
          #   "sntrup761x25519-sha512@openssh.com"
          #   "mlkem768x25519-sha256"
          # ];
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
      pam.rssh = {
        enable = true;
        settings = {
          authorized_keys_command = config.services.openssh.authorizedKeysCommand;
          authorized_keys_command_user = config.services.openssh.authorizedKeysCommandUser;
        };
      };
      wrappers.nethoscope = {
        owner = "tomas";
        group = "tomas";
      };
      # sudo.enable = false;
      # sudo-rs.enable = true;
    };

    programs = {
      fzf.fuzzyCompletion = true;
      # mosh.enable = true;
      dconf.enable = true;
      sharing.enable = true;
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
      iotop.enable = true;
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
        # kexAlgorithms = config.services.openssh.settings.KexAlgorithms;
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
      # mcelog.enable = true;
      rasdaemon.enable = true;
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
