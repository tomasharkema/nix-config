{ config, lib, pkgs, inputs, ... }:
with lib; {

  config = {
    #programs.singularity.enable = true;

    services = {
      kbfs = {
        enable = true;
        enableRedirector = true;
        # mountPoint = "/run/user/1002/keybase/kbfs";
        # extraFlags = ["-label tomas"];
      };

      keybase = { enable = true; };
    };
    security.wrappers.keybase-redirector = {
      owner = "root";
      group = "wheel";
      setuid = true;
    };

    environment.systemPackages = with pkgs;
      mkIf (config.gui.enable && pkgs.system == "x86_64-linux") [ keybase-gui ];

    # environment.systemPackages = with pkgs; [keybase kbfs];
  };
}
