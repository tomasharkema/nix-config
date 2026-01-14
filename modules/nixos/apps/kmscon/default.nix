{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.kmscon;
in {
  options.apps.kmscon = {
    enable = lib.mkEnableOption "kmscon";
    enableMouse = lib.mkEnableOption "enable mouse";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.kmscon.enable;
        message = "kmscon apps is enabled but service is disabled :(";
      }
    ];

    services.kmscon = {
      enable = lib.mkDefault true;
      hwRender = true;
      useXkbConfig = true;
      extraConfig = lib.mkIf cfg.enableMouse ''
        mouse
      '';
      fonts = [
        {
          name = "JetBrainsMono Nerd Font Mono";
          package = pkgs.nerd-fonts.jetbrains-mono;
        }
      ];
    };

    systemd.services = {
      # enable??
      "kmscon" = lib.mkIf false {
        description = "KMS System Console";
        documentation = ["man:kmscon(1)"];
        after = [
          "plymouth-quit-wait.service"
          "systemd-user-sessions.service"
          # "rc-local.service"
        ];

        serviceConfig.ExecStart = "${pkgs.kmscon}/bin/kmscon --login-program ${pkgs.shadow}/bin/login ${lib.getExe' pkgs.util-linux "agetty"} --noclear %I $TERM";

        wantedBy = ["multi-user.target"];
      };
      "kmsconvt@" = {
        # after = lib.mkOverride [
        #   "plymouth-quit-wait.service"
        #   "systemd-user-sessions.service"
        #   "rc-local.service"
        # ];
        before = ["getty.target"];

        unitConfig = {
          Conflicts = "getty@%i.service";
          OnFailure = "getty@%i.service";
          IgnoreOnIsolate = "yes";
          ConditionPathExists = "/dev/tty0";
        };

        serviceConfig = {
          UtmpIdentifier = "%I";
          TTYPath = "/dev/%I";
          TTYReset = "yes";
          TTYVHangup = "yes";
          TTYVTDisallocate = "yes";
        };

        wantedBy =
          lib.mkIf (!(config.systemd.services.display-manager.enable or false))
          ["getty.target"];

        requires = ["systemd-logind.service"];
      };
    };
  };
}
