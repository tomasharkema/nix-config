{
  options,
  config,
  lib,
  inputs,
  ...
}:
with lib; {
  imports = with inputs; [
    home-manager.nixosModules.home-manager
    # ../../home/default
  ];

  options.home = with types; {
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
    home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.home.configFile;
      programs = mkAliasDefinitions options.home.programs;
    };

    home-manager = {
      useUserPackages = true;

      users.${config.custom.user.name} =
        mkAliasDefinitions options.home.extraOptions;
    };
  };
}
