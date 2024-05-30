{ config, pkgs, lib, ... }:
with lib;
with lib.custom;
let cfg = config.netdata;
in {
  options.netdata = {
    enable = mkBoolOpt true "SnowflakeOS GNOME configuration";
  };

  config = mkIf cfg.enable {
    # age.secrets."netdata" = {file = ../secrets/netdata.age;};
    services.netdata = {
      enable = true;
      package = pkgs.netdataCloud;
      claimTokenFile = config.age.secrets."netdata".path;
    };
  };
}
