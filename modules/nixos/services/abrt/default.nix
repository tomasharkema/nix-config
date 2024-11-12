{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.abrt;
in {
  options.services.abrt = {enable = lib.mkEnableOption "abrt";};

  config = lib.mkIf cfg.enable {
    users = {
      groups.abrt = {};
    };

    environment = {
      systemPackages = [pkgs.abrt];
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

      services = {
        abrtd = {
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStartPre = "${pkgs.bash}/bin/bash -c \"${pkgs.procps}/bin/pkill ${pkgs.abrt}/bin/abrt-dbus || :\"";
            ExecStart = "${pkgs.abrt}/sbin/abrtd -d -s";

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
      packages = [pkgs.abrt];
    };
    security.polkit = {
      enable = true;
    };
  };
}
