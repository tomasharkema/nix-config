{
  pkgs,
  config,
  lib,
  ...
}: {
  options.apps.opensnitch = {
    enable = lib.mkEnableOption "opensnitch";
  };

  config = {
    environment.systemPackages = with pkgs; [opensnitch-ui];

    services.opensnitch = {
      enable = true;
      settings = {
        DefaultAction = "allow";
      };
    };
  };
}
