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
  cfg = config.gui.gnome;
in {
  options.gui.gnome = {
    enable = mkEnableOption "hallo";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-settings-daemon.enable = true;
    services.gnome.gnome-browser-connector.enable = true;
    services.gnome.core-shell.enable = true;
    services.gnome.core-utilities.enable = true;
    services.gnome3.chrome-gnome-shell.enable = true;

    services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

    # nixpkgs.config.firefox.enableGnomeExtensions = true;
    services.gnome.chrome-gnome-shell.enable = true;

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.extension-list
      gnomeExtensions.dash-to-panel
      gnomeExtensions.vitals
      gnomeExtensions.appindicator
      gnome.gnome-tweaks
      gnome-firmware
      gjs
    ];

    programs.dconf.enable = true;
  };
}
