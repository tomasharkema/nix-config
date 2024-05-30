{ lib, config, ... }:
let cfg = config.wifi;
in with lib;
with lib.custom; {
  imports = [ ./wifi_module.nix ];

  options = {
    wifi = { enable = mkBoolOpt false "SnowflakeOS GNOME configuration"; };
  };

  config = mkIf cfg.enable {
    # age.secrets.wireless = {
    #   file = ../secrets/wireless.age;
    #   mode = "0664";
    # };
    networking.networkmanager.enable = mkDefault true;
    networking.wireless = {
      environmentFile = config.age.secrets."wireless".path;
      networks = {
        "Have a good day".psk =
          "0fcc36c0dd587f3d85028f427c872fead0b6bb7623099fb4678ed958f2150e23";
      };
    };
  };
}
