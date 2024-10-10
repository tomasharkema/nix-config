{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  conkyConfig = builtins.readFile ./conky.lua;
  linux = lib.optional (pkgs.stdenv.isLinux && osConfig.gui.enable && osConfig.gui.gnome.enable) {
    services.conky = {
      enable = true;
      extraConfig = conkyConfig;
    };

    systemd.user.services.conky.Install.WantedBy = ["graphical-session.target"];
  };

  darwin = lib.optional (pkgs.stdenv.isDarwin && false) {
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
  config = lib.mkMerge (linux ++ darwin);
}
