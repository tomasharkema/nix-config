{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  home, # The home architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format, # A normalized name for the home target (eg. `home`).
  virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host, # The host name for this home.
  # All other arguments come from the home home.
  config,
  ...
}: let
  inherit (pkgs) stdenv;
  inherit (lib) mkIf;
  cfg = config.plusultra.user;

  is-linux = stdenv.isLinux;
  is-darwin = stdenv.isDarwin;

  home-directory =
    if is-darwin
    then "/Users/tomas"
    else "/home/tomas";
in {
  # Your configuration.

  config = {
    # home.username = lib.mkDefault "tomas";
    # home.homeDirectory = lib.mkDefault "/home/tomas";
    environment.systemPath = mkIf is-darwin [
      "/opt/homebrew/bin"
    ];

    programs.home-manager.enable = true;

    home.stateVersion = "23.11";

    home.sessionVariables = mkIf stdenv.isDarwin {
      EDITOR = "subl";
      SSH_AUTH_SOCK = "/Users/tomas/.1password/agent.sock";
      SPACESHIP_PROMPT_ADD_NEWLINE = "false";
    };

    age.identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "${home-directory}/.ssh/id_ed25519"
      "${home-directory}/.ssh/id_rsa"
    ];
  };
}
