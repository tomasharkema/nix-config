{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.apps.steam;
in {
  options.apps.steam = {
    enable = mkEnableOption "steam";
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["steam"];
    boot.kernelModules = ["uinput"];
    users.groups.input.members = ["tomas"];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall =
        true;
      dedicatedServer.openFirewall =
        true;
      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # sunshine
      protontricks
      # heroic
      # cartridges
      steamcmd
    ];

    # services.udev.extraRules = ''
    #   Sunshine
    #   KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
    # '';
    # security.wrappers.sunshine = {
    #   owner = "root";
    #   group = "root";
    #   capabilities = "cap_sys_admin+p";
    #   source = "${pkgs.sunshine}/bin/sunshine";
    # };

    # systemd.user.services.sunshine = {
    #   description = "sunshine";
    #   wantedBy = ["graphical-session.target"];
    #   serviceConfig = {
    #     ExecStart = "${config.security.wrapperDir}/sunshine";
    #   };
    # };

    # services.avahi.publish.userServices = true;
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
