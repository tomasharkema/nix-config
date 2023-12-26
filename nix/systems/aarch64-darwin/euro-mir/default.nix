{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      tomas-pkgs.maclaunch
      # kitty
      # terminal-notifier
      # maclaunch
      # launchcontrol
      # vagrant
      # fig
    ];
  };
}
