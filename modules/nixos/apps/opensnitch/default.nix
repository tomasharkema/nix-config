{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.apps.opensnitch;
in {
  options.apps.opensnitch = {enable = lib.mkEnableOption "opensnitch";};

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [opensnitch-ui];

    services.opensnitch = {
      enable = true;
      settings = {DefaultAction = "allow";};
    };
  };
}
