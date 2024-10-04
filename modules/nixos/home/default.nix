{
  options,
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.home = {
    homeFiles = lib.mkOption {
      description = "Attribute set of files to link into the user home.";
      default = {};
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          source = lib.mkOption {type = lib.types.path;};
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
        owner = "${config.user.name}";
      };
    };

    snowfallorg.users."${config.user.name}".home.config = {
      home.stateVersion = lib.mkDefault "24.11";
      xdg.enable = true;
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";
      users."${config.user.name}" = {
        home.stateVersion = lib.mkDefault "24.11";
        xdg.enable = true;
      };
    };

    services = {
      homed.enable = true;
      userdbd.enable = true;
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };
  };
}
