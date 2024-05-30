{ config, pkgs, lib, inputs, ... }:
with lib;
with lib.custom;
let cfg = config.traits.builder;
in {
  options.traits = {
    builder = { enable = mkBoolOpt false "SnowflakeOS GNOME configuration"; };
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
      #   file = "${../../secrets/ght.age}";
      #   mode = "0664";
      # };
      # age.secrets."ght-runner" = {
      #   file = ../../../secrets/ght-runner.age;
      #   mode = "0664";
      # };

      # services.github-runners."${config.networking.hostName}-runner-1" = github-default;
      # services.github-runners."${config.networking.hostName}-runner-2" = github-default;
    };
}
