{
  options,
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; {
  options.home = {
    homeFiles = mkOption {
      description = "Attribute set of files to link into the user home.";
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          source = mkOption {type = types.path;};
          # target = mkOption {
          #   type = types.str;
          # };
        };
      });
    };
  };

  config = {
    age.secrets = {
      openai = {
        rekeyFile = ./openai.age;
        owner = "tomas";
      };
    };

    snowfallorg.user.${config.user.name}.home.config = {
      home.stateVersion = mkDefault "24.05";
      xdg.enable = true;
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";
      users.${config.user.name} = {
        home.stateVersion = mkDefault "24.05";
        xdg.enable = true;
      };
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };
  };
}
