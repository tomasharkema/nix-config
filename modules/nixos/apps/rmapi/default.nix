{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    age.secrets."rmapi" = {
      rekeyFile = ./rmapi.age;
      mode = "644";
      path = "${config.home.homeDirectory}/.config/rmapi/rmapi.conf";
      owner = "tomas";
      group = "tomas";
    };

    system.activationScripts.rmapi = ''
      ln -sfn ${config.home.homeDirectory}/.config/rmapi/rmapi.conf ${config.home.homeDirectory}/.rmapi
    '';

    environment.systemPackages = with pkgs; [
      rmapi
      pkgs.custom.astounding
    ];
  };
}
