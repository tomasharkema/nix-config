{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.gui;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # spotify
      spotifyd

      ncspot
    ];

    services.spotifyd = {
      enable = true;
      # config = ''
      #   [global]
      #   username_cmd = "${lib.getExe pkgs._1password} item get bnzrqxggvfbfhgln4uceawfbbq --field username"
      #   password_cmd = "${lib.getExe pkgs._1password} item get bnzrqxggvfbfhgln4uceawfbbq --field password"
      # '';
    };
    systemd.services.spotifyd = {
      # environment = {
      #   OP_CONNECT_HOST = "http://silver-star.ling-lizard.ts.net:7080";
      #   OP_CONNECT_TOKEN = "${config.age.secrets.op.path}";
      # };
    };

    networking.firewall = {
      allowedUDPPorts = [33677];
      allowedTCPPorts = [33677];
    };
  };
}
