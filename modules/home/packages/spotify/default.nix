{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: {
  config = {
    home = {
      # file = {
      #   ".config/spotify-tui/client.yml".source = osConfig.age.secrets.spotify-tui.path;
      # };
      activation = {
        spotify-tui = ''
          ln -s "${osConfig.age.secrets.spotify-tui.path}" "$HOME/.config/spotify-tui/client.yml"
        '';
      };
      packages = with pkgs; [
        ncspot
        spotify-tui
      ];
    };
  };
}
