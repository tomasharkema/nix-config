{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.remote-unlock;

  mkKeysScript = let
    torRc = pkgs.writeText "tor.rc" ''
      DataDirectory /tmp/my-dummy.tor/
      SOCKSPort 127.0.0.1:10050 IsolateDestAddr
      SOCKSPort 127.0.0.1:10063
      HiddenServiceDir /etc/tor/onion/bootup
      HiddenServicePort 1234 127.0.0.1:1234
    '';
  in ''
    mkdir -p /etc/ssh/boot || true

    if [ ! -f "/etc/ssh/boot/ssh_host_ecdsa_key" ]; then
      ${pkgs.openssh}/bin/ssh-keygen -t ecdsa -N "" -f /etc/ssh/boot/ssh_host_ecdsa_key -q
    fi

    if [ ! -f "/etc/ssh/boot/ssh_host_ed25519_key" ]; then
     ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -f /etc/ssh/boot/ssh_host_ed25519_key -q
    fi

    if [ ! -f "/etc/ssh/boot/ssh_host_rsa_key" ]; then
     ${pkgs.openssh}/bin/ssh-keygen -t rsa -N "" -f /etc/ssh/boot/ssh_host_rsa_key -q
    fi

    if [ ! -d "/etc/secureboot" ]; then
      ${pkgs.sbctl}/bin/sbctl create-keys
    fi

    if [ ! -f "/etc/tor/onion/bootup/hostname" ]; then
      chmod 700 -R /etc/tor/onion/bootup
      mkdir -p /tmp/my-dummy.tor/
      (timeout 1m ${pkgs.tor}/bin/tor -f ${torRc}) || true
      cat /etc/tor/onion/bootup/hostname
      rm -rf /tmp/my-dummy.tor/
    fi
  '';
in {
  options.traits = {
    hardware.remote-unlock = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.remote-unlock-keys.text = mkKeysScript;
    # environment.systemPackages = with pkgs; [dracut];

    system.build = {
      mkKeysScript = lib.mkBefore pkgs.writeShellScriptBin "mkkeysscript" mkKeysScript;
    };

    boot = {
      crashDump.enable = true;
      initrd = {
        # verbose = true;
        compressorArgs = ["-19"];

        secrets = {
          "/etc/tor/onion/bootup" = "/etc/tor/onion/bootup";
          "/etc/ssh/boot/ssh_host_ecdsa_key" = "/etc/ssh/boot/ssh_host_ecdsa_key";
          "/etc/ssh/boot/ssh_host_ed25519_key" = "/etc/ssh/boot/ssh_host_ed25519_key";
          "/etc/ssh/boot/ssh_host_rsa_key" = "/etc/ssh/boot/ssh_host_rsa_key";
          "/etc/notify.key" = "${config.age.secrets.notify.path}";
        };

        systemd = {
          initrdBin = with pkgs; [
            haveged
            iproute2
            ntp
            rsyslog
            tor
            zerotierone
            notify
          ];

          packages = with pkgs; [
            haveged
            iproute2
            ntp
            rsyslog
            tor
            zerotierone
            notify
          ];

          # emergencyAccess = true;
          enable = true;

          users.root.shell = "/bin/systemd-tty-ask-password-agent";

          # services.haveged = {
          #   script = "haveged -F";
          #   before = ["network-pre.target"];
          #   wants = ["network-pre.target"];
          # };

          # services.journald.extraConfig = ''
          #   ForwardToConsole=yes
          #   MaxLevelConsole=debug
          # '';

          # contents."/etc/systemd/journald.conf".text = ''
          #   [Journal]
          #   ForwardToConsole=yes
          #   MaxLevelConsole=debug
          # '';

          contents."/etc/tor/tor.rc".text = ''
            DataDirectory /etc/tor
            SOCKSPort 127.0.0.1:9050 IsolateDestAddr
            SOCKSPort 127.0.0.1:9063
            HiddenServiceDir /etc/tor/onion/bootup
            HiddenServicePort 22222 127.0.0.1:22222
          '';
          # contents."/etc/rsyslog.conf".text = ''
          #   *.*    @@nix.harke.ma:5140;RSYSLOG_SyslogProtocol23Format
          # '';

          storePaths = [
            "${pkgs.tor}/bin/tor"
            "${pkgs.rsyslog}/sbin/rsyslogd"
            "${pkgs.coreutils}/bin/mkdir"
            "${pkgs.notify}/bin/notify"
          ];

          services = {
            tor = {
              # serviceConfig.Type = "oneshot";

              wantedBy = ["initrd.target"];
              after = ["network.target" "initrd-nixos-copy-secrets.service"];

              # before = ["shutdown.target"];
              # conflicts = ["shutdown.target"];

              preStart = ''
                # ntpdate -4 0.nixos.pool.ntp.org

                echo "tor: preparing onion folder"
                # have to do this otherwise tor does not want to start
                chmod -R 700 /etc/tor

                # echo "make sure localhost is up"
                # ip a a 127.0.0.1/8 dev lo
                # ip link set lo up

                echo "tor: starting tor"
                /bin/tor -f /etc/tor/tor.rc --verify-config
              '';

              unitConfig.DefaultDependencies = false;
              serviceConfig = {
                ExecStart = "/bin/tor -f /etc/tor/tor.rc";
                Type = "simple";
                KillMode = "process";
                Restart = "on-failure";
              };
            };

            notify = {
              script = ''
                echo "OJOO!" | /bin/notify -bulk -pc /etc/notify.key
              '';

              wantedBy = ["initrd.target"];
              after = ["network.target" "initrd-nixos-copy-secrets.service"];
              serviceConfig = {Type = "oneshot";};
            };

            # syslog = {
            #   description = "Syslog Daemon";

            #   requires = ["syslog.socket"];
            #   wantedBy = ["initrd.target"];

            #   serviceConfig = {
            #     ExecStart = "/bin/rsyslogd -f /etc/rsyslog.conf -n";
            #     ExecStartPre = "mkdir -p /var/spool/rsyslog";
            #     # Prevent syslogd output looping back through journald.
            #     StandardOutput = "null";
            #   };
          };
        };

        availableKernelModules = ["e1000e" "r8169"];
        kernelModules = [
          "uas"
          # "usbcore"
          "usb_storage"
          "vfat"
          "nls_cp437"
          "nls_iso8859_1"
        ];

        network = {
          enable = true;
          flushBeforeStage2 = true;

          # udhcpc.enable = true;
          ssh = {
            enable = true;
            port = 22222;
            # shell = "/bin/cryptsetup-askpass";
            authorizedKeys = lib.splitString "\n" (builtins.readFile pkgs.custom.authorized-keys);
            hostKeys = [
              "/etc/ssh/boot/ssh_host_ed25519_key"
              "/etc/ssh/boot/ssh_host_rsa_key"
              "/etc/ssh/boot/ssh_host_ecdsa_key"
            ];
          };
        };
      };
      kernelParams = ["ip=dhcp"];
    };
  };
}
