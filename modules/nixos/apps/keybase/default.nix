{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  wrapperDir = config.security.wrapperDir;
in {
  config = {
    security.wrappers.keybase-redirector = {
      owner = "root";
      group = "root";
      setuid = true;
    };
    systemd.user.services.kbfs.serviceConfig = {
      RuntimeDirectory = "%t/keybase";
      #   path = ["/run/wrappers/bin"];
      #   Environment = ["PATH=/run/wrappers/bin:$PATH"];
      EnvironmentFile = [
        "-%t/keybase/keybase.kbfs.env"

        "-%h/.config/keybase/keybase.autogen.env"
        "-%h/.config/keybase/keybase.env"
      ];
      ExecStart = mkForce "${pkgs.kbfs}/bin/kbfsfuse";
      ExecStartPre = mkForce [
        # "-${wrapperDir}/fusermount -uz \"${config.services.kbfs.mountPoint}\""
      ];
      #   DeviceAllow = ["/dev/fuse"];
      #   CapabilityBoundingSet = ["CAP_SYS_ADMIN"];
      #   #   ExecStartPre = ["/bin/sh -c 'which fusermount'"];
    };
    # systemd.user.services.kbfs.path = mkForce [];
    # systemd.user.services.kbfs = let
    #   wrapperDir = config.security.wrapperDir;
    # in {
    #   serviceConfig = {
    #     EnvironmentFile = [
    #       "-%t/keybase/keybase.kbfs.env"

    #       "-%h/.config/keybase/keybase.autogen.env"
    #       "-%h/.config/keybase/keybase.env"
    #     ];
    #     ExecStartPre = mkForce [
    #       "-${wrapperDir}/fusermount -uz \"$(${pkgs.keybase}/bin/keybase config get -d -b mountdir)\""
    #     ];
    #     ExecStart = mkForce "${pkgs.kbfs}/bin/kbfsfuse";
    #     ExecStop = mkForce "${wrapperDir}/fusermount -uz \"$(${pkgs.keybase}/bin/keybase config get -d -b mountdir)\"";
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
        mountPoint = "%t/keybase/kbfs";
      };
    };
    environment.systemPackages = with pkgs; (
      optional (config.gui.enable && pkgs.system == "x86_64-linux") keybase-gui
    );
    # ++ [keybase kbfs];
  };
}
