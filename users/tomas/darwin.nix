{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.overlays = import ../../lib/overlays.nix
  #   ++ [ (import ./vim.nix { inherit inputs; }) ];

  homebrew = {
    enable = true;
    casks = [
      "1password"
      "cleanshot"
      "discord"
      "google-chrome"
      "hammerspoon"
      "imageoptim"
      "istat-menus"
      "monodraw"
      "raycast"
      "rectangle"
      "screenflow"
      "slack"
      "spotify"
    ];
  };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.tomas = {
    home = "/Users/tomas";
    shell = pkgs.fish;
  };
}
