{ pkgs, inputs, ... }: {
  services.gnome.gnome-settings-daemon.enable = true;
  services.gnome.gnome-browser-connector.enable = true;
  services.gnome.core-shell.enable = true;
  services.gnome.core-utilities.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  nixpkgs.config.firefox.enableGnomeExtensions = true;
  services.gnome.chrome-gnome-shell.enable = true;

  environment.gnome.excludePackages = (with pkgs; [ gnome-photos gnome-tour ])
    ++ (with pkgs.gnome; [
      gnome-music
      gnome-terminal
      gedit # text editor
      evince # document viewer
      gnome-characters
      totem # video player
    ]);

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.gsconnect
    gnomeExtensions.extension-list
    gnomeExtensions.dash-to-panel
    gnomeExtensions.vitals
    gnomeExtensions.appindicator
    gnome.gnome-tweaks
    inputs.nix-software-center.packages.${system}.nix-software-center
  ];

  programs.dconf.enable = true;
  # programs.kdeconnect.enable = true;
}
