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
    snowfallorg.user.${config.user.name}.home.config = {
      home.stateVersion = mkDefault "23.11";
      xdg.enable = true;
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";
      users.${config.user.name} = {
        home.stateVersion = mkDefault "23.11";
        xdg.enable = true;
      };
    };
  };
}
