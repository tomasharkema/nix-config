{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.trait.builder;
in {
  options.trait = {
    builder = {enable = lib.mkEnableOption "builder";};
  };

  config = let
    github-default = {
      enable = true;
      tokenFile = config.age.secrets.ght-runner.path;
      url = "https://github.com/tomasharkema/nix-config";
      ephemeral = true;
      extraLabels = ["nixos"];
      # runnerGroup = "nixos";
    };
  in
    lib.mkIf cfg.enable {
      age.secrets."ght-runner" = {
        rekeyFile = ./ght-runner.age;
        mode = "0664";
      };

      services.github-runners = {
        "${config.networking.hostName}-runner-1" = github-default;
        # "${config.networking.hostName}-runner-2" = github-default;
      };
    };
}
