{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.trait.builder;
  user = "github-runner";
  group = "github-runner";
in {
  options.trait = {
    builder = {enable = lib.mkEnableOption "builder";};
  };

  config = let
    github-default = {
      inherit user group;
      enable = true;
      tokenFile = config.age.secrets.ght-runner.path;
      url = "https://github.com/tomasharkema/nix-config";
      ephemeral = true;
      replace = true;
      extraLabels = ["nixos" pkgs.stdenv.hostPlatform.system];
      extraPackages = with pkgs; [cachix];
    };
  in
    lib.mkIf cfg.enable {
      age.secrets."ght-runner" = {
        rekeyFile = ./ght-runner.age;
        owner = user;
        inherit group;
      };

      services.github-runners = {
        "${config.networking.hostName}-runner-1" = github-default;
        "${config.networking.hostName}-runner-2" = github-default;
      };

      users = {
        users.${user} = {
          inherit group;
          isSystemUser = true;
        };
        groups.${group} = {};
      };
      nix.settings.trusted-users = [
        user
      ];
    };
}
