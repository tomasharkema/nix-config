{
  pkgs,
  inputs,
  ...
}: {
  services.gnome.gnome-settings-daemon.enable = true;
  services.gnome.gnome-browser-connector.enable = true;
  services.gnome.core-shell.enable = true;
  services.gnome.core-utilities.enable = true;
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  nixpkgs.config.firefox.enableGnomeExtensions = true;
  services.gnome.chrome-gnome-shell.enable = true;

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.gsconnect
    gnomeExtensions.extension-list
    gnomeExtensions.dash-to-panel
    gnomeExtensions.vitals
    gnomeExtensions.appindicator
    gnome.gnome-tweaks
    gnome-firmware
    gjs
    inputs.nix-software-center.packages.${system}.nix-software-center
  ];

  programs.dconf.enable = true;
  # programs.kdeconnect.enable = true;
}
