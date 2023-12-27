{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      custom.maclaunch
      kitty
      terminal-notifier
      custom.launchcontrol
      # vagrant
      # fig
    ];

    services.nix-daemon.enable = true;

    security.pam.enableSudoTouchIdAuth = true;

    system.stateVersion = 4;
  };
}
