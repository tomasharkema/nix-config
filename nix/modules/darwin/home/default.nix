{
  config,
  inputs,
  lib,
  options,
  ...
}:
with lib; {
  # imports = [../../nixos/home];
  imports = with inputs; [
    home-manager.darwinModules.home-manager
    # ../../home/default
  ];

  options.custom.home = with types; {
    file = mkOption {
      type = types.attrs;
      default = {};
      description = "derp";
    };
    # "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = mkOption {
      type = types.attrs;
      default = {};
      description = "derp";
    };
    # "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    programs = mkOption {
      type = types.attrs;
      default = {};
      description = "derp";
    };
    #"Programs to be managed by home-manager.";
    extraOptions = mkOption {
      type = types.attrs;
      default = {};
      description = "derp";
    };
    #"Options to pass directly to home-manager.";
  };

  config = {
    custom.home.extraOptions = {
      home.stateVersion = "23.11"; #config.system.stateVersion;
      home.file = mkAliasDefinitions options.custom.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.custom.home.configFile;
      programs = mkAliasDefinitions options.custom.home.programs;
    };

    # snowfallorg.user.${config.user.name}.home.config = mkAliasDefinitions options.custom.home.extraOptions;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.${config.user.name} = mkAliasDefinitions options.custom.home.extraOptions;
    };
  };
}
