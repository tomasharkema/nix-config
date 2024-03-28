{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.apps.spotifyd;
in {
  options.apps.spotifyd = {
    enable = mkEnableOption "spotifyd";
  };

  config = mkIf cfg.enable {
    #   environment.systemPackages = with pkgs; [
    #     # spotify
    #     spotifyd
    #   ];
    users.users."tomas".extraGroups = ["audio"];
    users.users."root".extraGroups = ["audio"];

    services.spotifyd = {
      enable = true;
      config = ''
        [global]
        use_mpris = false
        backend = "pulseaudio"
        bitrate = 320
      '';
      #   username_cmd = "${lib.getExe pkgs._1password} item get bnzrqxggvfbfhgln4uceawfbbq --field username"
      #   password_cmd = "${lib.getExe pkgs._1password} item get bnzrqxggvfbfhgln4uceawfbbq --field password"
    };
    #   # systemd.services.spotifyd = {
    #   # environment = {
    #   #   OP_CONNECT_HOST = "http://silver-star.ling-lizard.ts.net:7080";
    #   #   OP_CONNECT_TOKEN = "${config.age.secrets.op.path}";
    #   # };
    #   # };

    networking.firewall = {
      allowedUDPPorts = [33677];
      allowedTCPPorts = [33677];
    };
    # };
  };
}
