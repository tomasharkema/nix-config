{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.home;
in {
  config = {
    programs.zsh.enable = true;
    snowfallorg.user."tomas".home.config = {
      home.stateVersion = mkDefault "23.11";
      xdg.enable = true;
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users."tomas" = {
        home.stateVersion = mkDefault "23.11";
        xdg.enable = true;
      };
    };
  };
}
