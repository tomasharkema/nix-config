{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  config = mkIf (!config.traits.slim.enable) {
    services.kbfs = {
      enable = true;
      enableRedirector = true;
    };
    services.keybase = {
      enable = true;
    };
    security.wrappers.keybase-redirector.owner = "tomas";
    security.wrappers.keybase-redirector.group = "tomas";
    environment.systemPackages = with pkgs; mkIf (config.gui.enable && pkgs.system == "x86_64-linux") [keybase-gui];

    # environment.systemPackages = with pkgs; [keybase kbfs];
  };
}
