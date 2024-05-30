{ config, lib, pkgs, inputs, ... }:
with lib; {
  # disabledModules = ["services/network-filesystems/kbfs.nix"];

  # imports = [
  #   "${inputs.unstable}/nixos/modules/services/network-filesystems/kbfs.nix"
  # ];

  config = mkIf (!config.traits.slim.enable) {
    #programs.singularity.enable = true;

    services.kbfs = {
      enable = true;
      enableRedirector = true;
      # mountPoint = "/run/user/1002/keybase/kbfs";
      # extraFlags = ["-label tomas"];
    };
    services.keybase = { enable = true; };
    security.wrappers.keybase-redirector.owner = "tomas";
    security.wrappers.keybase-redirector.group = "tomas";
    security.wrappers.keybase-redirector.setuid = true;

    environment.systemPackages = with pkgs;
      mkIf (config.gui.enable && pkgs.system == "x86_64-linux") [ keybase-gui ];

    # environment.systemPackages = with pkgs; [keybase kbfs];
  };
}
