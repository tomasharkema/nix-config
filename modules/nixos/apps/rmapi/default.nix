{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf false {
    age.secrets."rmapi" = {
      rekeyFile = ./rmapi.age;
      mode = "644";
      path = "/home/tomas/.config/rmapi/rmapi.conf";
      owner = "tomas";
      group = "tomas";
    };

    system.activationScripts.rmapi = ''
      ln -sfn /home/tomas/.config/rmapi/rmapi.conf /home/tomas/.rmapi
    '';

    environment.systemPackages = with pkgs; [
      rmapi
      pkgs.custom.astounding
    ];
  };
}
