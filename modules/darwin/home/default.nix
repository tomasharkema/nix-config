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
  # options.home = {
  #   homeFiles = mkOption {
  #     description = "Attribute set of files to link into the user home.";
  #     default = {};
  #     type = types.attrsOf (types.submodule {
  #       options = {
  #         source = mkOption {type = types.path;};
  #         # target = mkOption {
  #         #   type = types.str;
  #         # };
  #       };
  #     });
  #   };
  # };
  config = {
    environment = {
      variables.XDG_DATA_DIRS = ["/usr/local/share"];
      systemPackages = with pkgs; [virt-manager];
    };

    snowfallorg.users."tomas" = {
      create = true;
      # admin = true;

      home = {
        enable = true;
        config = {
          home.stateVersion = mkDefault "24.05";
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

      users.tomas = {
        home.stateVersion = mkDefault "24.05";
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
