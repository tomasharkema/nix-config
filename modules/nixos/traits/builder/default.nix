{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.builder;
in {
  options.traits = {
    builder = {enable = mkEnableOption "SnowflakeOS GNOME configuration";};
  };

  config =
    # let
    #   github-default = {
    #     enable = true;
    #     tokenFile = config.age.secrets.ght-runner.path;
    #     url = "https://github.com/tomasharkema/nix-config";
    #     ephemeral = true;
    #   };
    # in
    mkIf cfg.enable {
      # age.secrets.ght = {
      #   rekeyFile = "${../../secrets/ght.age}";
      #   mode = "0664";
      # };
      # age.secrets."ght-runner" = {
      #   rekeyFile = ../../../secrets/ght-runner.age;
      #   mode = "0664";
      # };

      # services.github-runners."${config.networking.hostName}-runner-1" = github-default;
      # services.github-runners."${config.networking.hostName}-runner-2" = github-default;
    };
}
