{ config, pkgs, lib, inputs, ... }:
with lib;
# let
#   theme = inputs.themes.custom (inputs.themes.catppuccin-mocha
#     // {
#       base00 = "000000";
#     });
# in

let
  postBuildScript = pkgs.writeScript "upload-to-cache.sh" ''
    set -eu
    set -f # disable globbing
    export IFS=' '

    echo "Uploading paths" $OUT_PATHS
    # exec nix copy --to "s3://example-nix-cache" $OUT_PATHS
  '';
in {

  config = with lib; {
    # Set your time zone.
    time.timeZone = "Europe/Amsterdam";

    environment.variables.XCURSOR_SIZE = "24";

    # nix.package = pkgs.nixVersions.nix_2_22; #Unstable;

    nix.settings.post-build-hook = postBuildScript;

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

    zramSwap = { enable = mkDefault true; };

    console = {
      earlySetup = true;
      #   font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
      #      packages = with pkgs; [ terminus_font ];
      #   #    keyMap = "us";
      useXkbConfig = true; # use xkb.options in tty.
    };

    boot = {
      initrd.systemd.emergencyAccess = true;

      crashDump.enable = true;

      hardwareScan = true;

      kernel.sysctl."net.ipv4.ip_forward" = 1;

      tmp = mkDefault {
        useTmpfs = false;
        cleanOnBoot = false;
      };

      # kernelPackages = lib.mkDefault pkgs.linuxPackages_6_7;
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      loader = {
        systemd-boot = {
          netbootxyz.enable = true;
          configurationLimit = 20;
        };
      };
    };

    environment.systemPackages = (with pkgs; [
      socat
      gdu
      swapview
      devenv
      nix-web
      nix-pin
      nix-doc
      nix-update
      nix-bundle
      nix-bisect
      nix-plugins
      nix-inspect
      # nix-janitor
      nixos-option
      # nix-delegate
      nix-visualize
      nix-update-source
      nix-simple-deploy
      nix-query-tree-viewer

      # nix-switcher : needs github auth

      nux
      disnix
      nox
      nh

      dfrs
      duc
      ssh-tools
      mbuffer
      # etcher
      pamixer
      pulsemixer
      pamix
      pavucontrol
      ponymix
      # ntfy
      ntfy-sh
      ntfs3g
      plex-mpv-shim
      # rtop
      ipcalc
      # fancy-motd
      kexec-tools
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
      nix-top
    ]) ++ (with pkgs.custom; [
      menu
      pvzstd
      ssm
      tailscale-tui
      sshed
      # rmfuse
    ]) ++ (optionals pkgs.stdenv.isx86_64 [
      pkgs.custom.ztui
      # pkgs.wolfram-engine
      pkgs.libsmbios
      pkgs.dmidecode
      pkgs.termius
    ]);
    # services.ntfy-sh.enable = true;

    apps = {
      attic.enable = mkDefault true;
      ipa.enable = mkDefault true;
      atop.enable = mkDefault true;
    };

    proxy-services.enable = mkDefault true;

    systemd = {
      enableEmergencyMode = mkDefault true;
      watchdog = {
        # device = "/dev/watchdog";
        runtimeTime = "10m";
        kexecTime = "10m";
        rebootTime = "10m";
      };

      user.services.auto-fix-vscode-server = {
        enable = true;
        wants = [ "multi-user.target" "network.target" ];
        after = [ "multi-user.target" "network.target" ];
      };

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
      kmscon = {
        enable = mkDefault true;
        hwRender = config.traits.hardware.nvidia.enable;
        fonts = [{
          name = "JetBrainsMono Nerd Font Mono";
          package = pkgs.nerdfonts;
        }];
      };

      preload.enable = true;

      ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };

      fstrim.enable = true;

      throttled.enable = pkgs.stdenv.isx86_64;

      cron.enable = true;

      zram-generator.enable = true;

      # earlyoom = {
      #   enable = true;
      #   enableNotifications = true;
      # };

      # vscode-server.enable = true;

      seatd.enable = true;

      # udisks2 = {
      #   enable = true;
      # };

      das_watchdog.enable = true;

      thermald.enable = mkIf (pkgs.system == "x86_64-linux") true;

      check_mk_agent = {
        enable = true;
        bind = "0.0.0.0";
        openFirewall = true;
        package = pkgs.check_mk_agent.override { enablePluginSmart = true; };
      };

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

    # security.sudo.package = pkgs.sudo.override { withSssd = true; };

    programs = {
      fzf.fuzzyCompletion = true;

      dconf.enable = true;

      # darling.enable = pkgs.stdenv.isx86_64;

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
          uptime = { prefix = "Up"; };
          # weather = {
          #   url = "https://wttr.in/Amsterdam";
          # };
          service_status = {
            Accounts = "accounts-daemon";
            Cron = "cron";
          };
          filesystems = { root = "/"; };
          memory = {
            swap_pos = "beside"; # or "below" or "none"
          };
          last_login = { tomas = 2; };
          last_run = { };
        };
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
      firewall = { enable = mkDefault true; };

      networkmanager.enable = mkDefault true;
    };

    # powerManagement.powertop.enable = mkDefault true;
    # programs.gnupg.agent.enable = true;
  };
}
