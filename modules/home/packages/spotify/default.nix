{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: {
  config = {
    # config = lib.mkIf cfg.enable {
    #   environment.systemPackages = with pkgs; [
    #     # spotify
    #     spotifyd
    #   ];

    #   services.spotifyd = {
    #     enable = true;
    #     config = ''
    #       [global]
    #       use_mpris = false
    #     '';
    #     #   username_cmd = "${lib.getExe pkgs._1password} item get bnzrqxggvfbfhgln4uceawfbbq --field username"
    #     #   password_cmd = "${lib.getExe pkgs._1password} item get bnzrqxggvfbfhgln4uceawfbbq --field password"
    #   };
    #   # systemd.services.spotifyd = {
    #   # environment = {
    #   #   OP_CONNECT_HOST = "http://silver-star.ling-lizard.ts.net:7080";
    #   #   OP_CONNECT_TOKEN = "${config.age.secrets.op.path}";
    #   # };
    #   # };

    #   networking.firewall = {
    #     allowedUDPPorts = [33677];
    #     allowedTCPPorts = [33677];
    #   };
    # };

    home = {
      # file = {
      #   ".config/spotify-tui/client.yml".source = osConfig.age.secrets.spotify-tui.path;
      # };
      activation = {
        # spotify-tui = ''
        #   mkdir -p "$HOME/.config/spotify-tui" || true
        #   ln -sfn "${osConfig.age.secrets.spotify-tui.path}" "$HOME/.config/spotify-tui/client.yml" || true
        # '';
      };
      packages = with pkgs; [
        ncspot
      ];
    };
  };
}
