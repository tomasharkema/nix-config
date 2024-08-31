{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  conkyConfig = builtins.readFile ./conky.lua;
  linux = optional (pkgs.stdenv.isLinux && osConfig.gui.enable && osConfig.gui.gnome.enable) {
    services.conky = {
      enable = true;
      extraConfig = conkyConfig;
    };

    systemd.user.services.conky.Install.WantedBy = ["default.target"];
  };

  darwin = optional (pkgs.stdenv.isDarwin && false) {
    home.packages = [pkgs.conky];

    launchd.agents."conky" = {
      enable = true;
      config = {
        ProgramArguments = ["${pkgs.conky}/bin/conky" "--config ${pkgs.writeText "conky.conf" conkyConfig}"];
        KeepAlive = true;
      };
    };
  };
in {
  config = mkMerge (linux ++ darwin);
}
