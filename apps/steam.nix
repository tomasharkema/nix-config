{
  # config,
  pkgs
, modulesPath
, ...
}: {
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
    # nvtop
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
    wantedBy = [ "graphical-session.target" ];
  };
}
