{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  wrapperDir = config.security.wrapperDir;
in {
  config = lib.mkIf false {
    security.wrappers.keybase-redirector = {
      owner = "root";
      group = "root";
      setuid = true;
      # source = "${pkgs.kbfs}/bin/redirector";
    };
    systemd.user.services = {
      kbfs = {
        path = ["/run/wrappers"];
        serviceConfig = {
          # ExecStartPre = ["-${pkgs.keybase}/bin/keybase keybase config set mountdir \"${config.services.kbfs.mountPoint}\""];

          #     wants = ["keybase.service" "keybase-redirector.service"];
          #     serviceConfig = {
          #       #   path = ["/run/wrappers/bin"];
          #       #   Environment = ["PATH=/run/wrappers/bin:$PATH"];
          EnvironmentFile = [
            "-%t/keybase/keybase.kbfs.env"

            "-%h/.config/keybase/keybase.autogen.env"
            "-%h/.config/keybase/keybase.env"
          ];
          ExecStart = lib.mkForce "${pkgs.kbfs}/bin/kbfsfuse -label Keybase /run/user/1000/kbfs";
          ExecStartPre = lib.mkForce [
            # "-${wrapperDir}/fusermount -uz \"${config.services.kbfs.mountPoint}\""
          ];
          PrivateTmp = lib.mkForce false;
          #       #   DeviceAllow = ["/dev/fuse"];
          #       #   CapabilityBoundingSet = ["CAP_SYS_ADMIN"];
        };
      };

      keybase-redirector = {
        path = ["/run/wrappers"];
        #     description = "Keybase Root Redirector for KBFS";
        #     wants = ["keybase.service"];
        #     unitConfig.ConditionUser = "!@system";

        serviceConfig = {
          EnvironmentFile = [
            "-%E/keybase/keybase.autogen.env"
            "-%E/keybase/keybase.env"
          ];
          #       # Note: The /keybase mount point is not currently configurable upstream.
          #       ExecStart = "${wrapperDir}/keybase-redirector /keybase";
          #       Restart = "on-failure";
          #       # PrivateTmp = true;
          PrivateTmp = lib.mkForce false;
        };

        #     wantedBy = ["default.target"];
        #   };
      };
    };
    # systemd.user.services.kbfs.path = lib.mkForce [];
    # systemd.user.services.kbfs = let
    #   wrapperDir = config.security.wrapperDir;
    # in {
    #   serviceConfig = {
    #     EnvironmentFile = [
    #       "-%t/keybase/keybase.kbfs.env"

    #       "-%h/.config/keybase/keybase.autogen.env"
    #       "-%h/.config/keybase/keybase.env"
    #     ];
    #     ExecStartPre = lib.mkForce [
    #       "-${wrapperDir}/fusermount -uz \"$(${pkgs.keybase}/bin/keybase config get -d -b mountdir)\""
    #     ];
    #     ExecStart = lib.mkForce "${pkgs.kbfs}/bin/kbfsfuse";
    #     ExecStop = lib.mkForce "${wrapperDir}/fusermount -uz \"$(${pkgs.keybase}/bin/keybase config get -d -b mountdir)\"";
    #   };
    # };

    users = {
      users.tomas.extraGroups = ["kbfs" "fuse"];
      groups = {kbfs = {};};
    };

    services = {
      keybase = {
        enable = true;
      };

      kbfs = {
        enable = true;
        enableRedirector = true;
        mountPoint = "%t/kbfs";
        extraFlags = [
          "-label kbfs"
          "-mount-type normal"
        ];
      };
    };
    environment.systemPackages = with pkgs; (
      lib.optional (config.gui.enable && pkgs.system == "x86_64-linux") keybase-gui
    );
    # ++ [keybase kbfs];
  };
}
