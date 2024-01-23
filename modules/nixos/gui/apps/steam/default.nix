{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.gui.apps.steam;
in {
  options.gui.apps.steam = {
    enable = mkEnableOption "hallo";
  };

  config = mkIf cfg.enable {
    users.groups.input.members = ["tomas"];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall =
        true;
      dedicatedServer.openFirewall =
        true;
    };

    environment.systemPackages = with pkgs; [
      sunshine
      protontricks
    ];

    services.udev.extraRules = ''
      Sunshine
      KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
    '';

    systemd.services.sunshine = {
      enable = true;
      description = "Sunshine self-hosted game stream host for Moonlight.";
      unitConfig = {
        Type = "simple";
        StartLimitIntervalSec = 500;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        ExecStart = "${pkgs.sunshine}/bin/sunshine";
        Restart = "on-failure";
        RestartSec = 5;
      };
      wantedBy = ["graphical-session.target"];
    };

    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
