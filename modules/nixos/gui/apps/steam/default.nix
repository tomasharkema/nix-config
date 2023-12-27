{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
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
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };
    hardware.opengl.driSupport32Bit =
      true; # Enables support for 32bit libs that steam uses

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
        ExecStart = "${pkgs.sunshine}";
        Restart = "on-failure";
        RestartSec = 5;
      };
      wantedBy = ["graphical-session.target"];
    };
  };
}
