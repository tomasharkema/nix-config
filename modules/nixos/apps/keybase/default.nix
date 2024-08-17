{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  config = {
    security.wrappers.keybase-redirector = {
      owner = "root";
      group = "kbfs";
    };

    systemd.user.services.kbfs = let
      wrapperDir = config.security.wrapperDir;
    in {
      # EnvironmentFile=-%t/keybase/keybase.kbfs.env

      # EnvironmentFile=-%h/.config/keybase/keybase.autogen.env
      # EnvironmentFile=-%h/.config/keybase/keybase.env

      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStartPre = mkForce [
          "-${wrapperDir}/fusermount -uz \"$(${pkgs.keybase}/bin/keybase config get -d -b mountdir)\""
        ];
        ExecStart = mkForce "${pkgs.kbfs}/bin/kbfsfuse \"$(${pkgs.keybase}/bin/keybase config get -d -b mountdir)\"";
        ExecStop = mkForce "${wrapperDir}/fusermount -uz \"$(${pkgs.keybase}/bin/keybase config get -d -b mountdir)\"";
      };
    };

    services = {
      keybase = {
        enable = true;
      };

      kbfs = {
        enable = true;
        enableRedirector = true;
      };
    };
    environment.systemPackages = with pkgs;
      mkIf (config.gui.enable && pkgs.system == "x86_64-linux") [keybase-gui];

    # environment.systemPackages = with pkgs; [keybase kbfs];
  };
}
