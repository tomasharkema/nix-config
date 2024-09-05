{
  lib,
  config,
  ...
}: let
  cfg = config.wifi;
in {
  imports = [./wifi_module.nix];

  options = {
    wifi = {enable = lib.mkEnableOption "SnowflakeOS GNOME configuration";};
  };

  config = lib.mkIf cfg.enable {
    # age.secrets.wireless = {
    #   file = ../secrets/wireless.age;
    #   mode = "0664";
    # };
    networking.networkmanager.enable = lib.mkDefault true;
    networking.wireless = {
      environmentFile = config.age.secrets."wireless".path;
      networks = {
        "Have a good day".psk = "0fcc36c0dd587f3d85028f427c872fead0b6bb7623099fb4678ed958f2150e23";
      };
    };
  };
}
