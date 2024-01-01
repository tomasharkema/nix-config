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
    snowfallorg.user.${config.user.name}.home.config = {
      home.stateVersion = mkDefault "23.11";
      xdg.enable = true;
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.${config.user.name} = {
        home.stateVersion = mkDefault "23.11";
        xdg.enable = true;
      };
    };
  };
}
