{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; {
  config = {
    snowfallorg.user.${config.user.name}.home.config = {
      home.stateVersion = mkDefault "23.11";
      xdg.enable = true;
      home.sessionVariables = {
        HYDRA_HOST = "http://blue-fire.ling-lizard.ts.net:3000/"; # "https://hydra.harkema.io";
      };
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";

      users.${config.user.name} = {
        home.stateVersion = mkDefault "23.11";
        xdg.enable = true;
        home.sessionVariables = {
          HYDRA_HOST = "http://blue-fire.ling-lizard.ts.net:3000/"; # "https://hydra.harkema.io";
        };
      };
    };
  };
}
