{
  options,
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; {
  config = {
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
