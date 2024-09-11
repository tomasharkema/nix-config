{
  options,
  config,
  pkgs,
  lib,
  inputs,
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
        rekeyFile = ../../nixos/home/openai.age;
        owner = "${config.user.name}";
      };
    };

    environment = {
      # variables.XDG_DATA_DIRS = ["/usr/local/share"];
      # systemPackages = with pkgs; [virt-manager];
    };

    snowfallorg.users."${config.user.name}" = {
      create = true;
      # admin = true;

      home = {
        enable = true;
        config = {
          home.stateVersion = lib.mkDefault "24.11";
          xdg.enable = true;
          # home.sessionVariables = {
          #   HYDRA_HOST =
          #     "http://blue-fire.ling-lizard.ts.net:3000/"; # "https://hydra.harkema.io";
          # };

          programs.home-manager.enable = true;
        };
      };
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "bak";

      users."${config.user.name}" = {
        imports = [inputs.mac-app-util.homeManagerModules.default];
        home.stateVersion = lib.mkDefault "24.11";
        xdg.enable = true;
        programs.home-manager.enable = true;
        # home.sessionVariables = {
        #   HYDRA_HOST =
        #     "http://blue-fire.ling-lizard.ts.net:3000/"; # "https://hydra.harkema.io";
        # };
      };
    };
  };
}
