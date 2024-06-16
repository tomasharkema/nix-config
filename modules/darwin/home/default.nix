{ options, config, pkgs, lib, inputs, ... }:
with lib;
with lib.custom; {
  options.home = {
    homeFiles = mkOption {
      description = "Attribute set of files to link into the user home.";
      default = { };
      type = types.attrsOf (types.submodule {
        options = {
          source = mkOption { type = types.path; };
          # target = mkOption {
          #   type = types.str;
          # };
        };
      });
    };
  };
  config = {
    snowfallorg.user.${config.user.name}.home.config = {
      home.stateVersion = mkDefault "24.05";
      xdg.enable = true;
      home.sessionVariables = {
        HYDRA_HOST =
          "http://blue-fire.ling-lizard.ts.net:3000/"; # "https://hydra.harkema.io";
      };
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";

      users.${config.user.name} = {
        home.stateVersion = mkDefault "24.05";
        xdg.enable = true;
        home.sessionVariables = {
          HYDRA_HOST =
            "http://blue-fire.ling-lizard.ts.net:3000/"; # "https://hydra.harkema.io";
        };
      };
    };
  };
}
