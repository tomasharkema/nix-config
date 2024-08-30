{ pkgs, config, lib, ... }:
with lib;
let cfg = config.apps.opensnitch;
in {
  options.apps.opensnitch = { enable = lib.mkEnableOption "opensnitch"; };

  config = mkIf (cfg.enable && false) {
    environment.systemPackages = with pkgs; [ opensnitch-ui ];

    services.opensnitch = {
      enable = true;
      settings = { DefaultAction = "allow"; };
    };
  };
}
