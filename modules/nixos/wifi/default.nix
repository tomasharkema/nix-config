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
}: let
  cfg = config.wifi;
in
  with lib; {
    imports = [./wifi_module.nix];

    options = {
      wifi = {
        enable = mkEnableOption "SnowflakeOS GNOME configuration";
      };
    };

    config = mkIf cfg.enable {
      # age.secrets.wireless = {
      #   file = ../secrets/wireless.age;
      #   mode = "0664";
      # };
      networking.networkmanager.enable = true;
      networking.wireless = {
        environmentFile = config.age.secrets."wireless".path;
        networks = {
          "Have a good day".psk = "0fcc36c0dd587f3d85028f427c872fead0b6bb7623099fb4678ed958f2150e23";
        };
      };
    };
  }
