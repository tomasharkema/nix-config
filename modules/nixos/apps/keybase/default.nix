{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  config = mkIf (!config.traits.slim.enable) {
    # inputs.unstable.legacyPackages.x86_64-linux.kbfs
    services.kbfs = {
      enable = true;
      # package = inputs.unstable.legacyPackages."${pkgs.system}".kbfs;
      enableRedirector = true;
    };
    services.keybase = {
      enable = true;
      # package = inputs.unstable.legacyPackages."${pkgs.system}".keybase;
    };
    security.wrappers.keybase-redirector.owner = "tomas";
    security.wrappers.keybase-redirector.group = "tomas";
    environment.systemPackages = with pkgs; mkIf (config.gui.enable && pkgs.system == "x86_64-linux") [keybase-gui];

    # environment.systemPackages = with pkgs; [keybase kbfs];
  };
}
