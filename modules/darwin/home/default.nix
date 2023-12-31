{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.home;
in {
  # imports = with inputs; [
  #   home-manager.darwinModules.home-manager
  # ];

  options.home = with types; {
    file =
      mkOpt attrs {}
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile =
      mkOpt attrs {}
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs {} "Options to pass directly to home-manager.";
    homeConfig = mkOpt attrs {} "Final config for home-manager.";
  };

  config = {
    home.extraOptions = {
      home.stateVersion = mkDefault "23.11";
      home.file = mkAliasDefinitions options.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.home.configFile;
    };

    snowfallorg.user.${config.user.name}.home.config = mkAliasDefinitions options.home.extraOptions;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}
