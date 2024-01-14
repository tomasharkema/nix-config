{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf (!config.traits.slim.enable) {
    services.kbfs = {
      enable = true;
    };
    services.keybase = {
      enable = true;
    };

    environment.systemPackages = with pkgs; mkIf config.gui.enable [keybase-gui];
  };
}
