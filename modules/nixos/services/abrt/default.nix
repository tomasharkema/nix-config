{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.abrt;
  package = pkgs.abrt;
in {
  options.services.abrt = {
    enable = lib.mkEnableOption "abrt";
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.abrt = {};
    };

    environment = {
      systemPackages = [package];
      etc."abrt/abrt.conf".text = ''
        #Type Path                  Mode UID  GID
        d     /var/tmp/abrt         0755 abrt abrt
        x     /var/tmp/abrt/*

        d     /run/abrt             0755 root root
        r!    /run/abrt/abrt.pid
        r!    /run/abrt/abrt.socket

        d     /var/cache/abrt-di    0775 abrt abrt
      '';
    };
    systemd = {
      # packages = [pkgs.abrt];

      tmpfiles.settings."10-meshagent" = {
        "/var/lib/abrt".d = {
          user = "abrt";
          group = "abrt";
          mode = "0755";
        };
        "/etc/abrt/plugins/oops.conf".L = {
          argument = "${package}/etc/abrt/plugins/oops.conf";
        };
        "/etc/abrt/plugins/CCpp.conf".L = {
          argument = "${package}/etc/abrt/plugins/CCpp.conf";
        };
      };

      services = {
        abrt-dump-journal-core = {
          description = "ABRT coredumpctl message creator";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];

          wantedBy = ["multi-user.target"];

          serviceConfig = {
            Type = "simple";
            ExecStart = "${package}/bin/abrt-dump-journal-core -D -T -f -e";
          };
        };

        abrt-dump-journal-oop = {
          description = "ABRT kernel log watcher";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${package}/bin/abrt-dump-journal-oops -fxtD";
          };
        };

        abrt-pstoreoops = {
          description = "ABRT kernel oops pstore collector";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];

          unitConfig = {
            ConditionDirectoryNotEmpty = "/sys/fs/pstore";
          };

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${package}/sbin/abrt-harvest-pstoreoops";
            RemainAfterExit = "yes";
          };
        };

        abrt-upload-watch = {
          description = "ABRT upload watcher";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${package}/sbin/abrt-upload-watch";
          };
        };

        abrt-vmcore = {
          description = "ABRT kernel panic detection";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];

          unitConfig = {
            ConditionDirectoryNotEmpty = "/var/crash";
          };

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${package}/sbin/abrt-harvest-vmcore";
            RemainAfterExit = "yes";
          };
        };

        abrt-xorg = {
          description = "ABRT Xorg log watcher";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${package}/bin/abrt-dump-journal-xorg -fxtD";
          };
        };

        abrtd = {
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStartPre = "${pkgs.bash}/bin/bash -c \"${pkgs.procps}/bin/pkill ${package}/bin/abrt-dbus || :\"";
            ExecStart = "${package}/bin/abrtd -d -s";

            Type = "dbus";
            BusName = "org.freedesktop.problems.daemon";
            DevicePolicy = "closed";
            KeyringMode = "private";
            LockPersonality = "yes";
            MemoryDenyWriteExecute = "yes";
            NoNewPrivileges = "yes";
            PrivateDevices = "yes";
            PrivateTmp = true;
            ProtectClock = "yes";
            ProtectControlGroups = "yes";
            ProtectHome = "read-only";
            ProtectHostname = "yes";
            ProtectKernelLogs = "yes";
            ProtectKernelModules = "yes";
            ProtectKernelTunables = "yes";
            ProtectProc = "invisible";
            ProtectSystem = "full";
            RestrictNamespaces = "yes";
            RestrictRealtime = "yes";
            RestrictSUIDSGID = "yes";
            SystemCallArchitectures = "native";
          };
        };
      };
    };
    services.dbus = {
      enable = true;
      packages = [package];
    };
    security.polkit = {
      enable = true;
    };
  };
}
