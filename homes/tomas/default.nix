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
  cfg = config.user;
  is-linux = stdenv.isLinux;
  is-darwin = stdenv.isDarwin;
  home-directory = user:
    if is-darwin
    then "/Users/${user}"
    else "/home/${user}";
in {
  # Your configuration.

  # config = {
  #   home.username = lib.mkDefault "tomas";
  #   home.homeDirectory = lib.mkDefault (home-directory "tomas");
  # };
}
