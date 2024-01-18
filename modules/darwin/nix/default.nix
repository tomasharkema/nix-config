{
  inputs,
  options,
  config,
  pkgs,
  lib,
  system,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.custom.nix;
in {
  imports = [
    inputs.agenix.darwinModules.default
  ];

  options = {
    custom.nix = with types; {
      enable = mkBoolOpt true "Whether or not to manage nix configuration.";
      package = mkOpt package pkgs.nix "Which nix package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inputs.deploy-rs.packages.${system}.deploy-rs
      nixfmt
      nix-index
      nix-prefetch-git
      inputs.nil.packages.${system}.default
      # flake-checker
      nixpkgs-fmt
    ];

    services.nix-daemon.enable = true;

    age.secrets."op" = {
      file = ../../../secrets/op.age;
      mode = "744";
      # path = "/home/tomas/.google_authenticator";
      # owner = "tomas";
      # group = "tomas";
    };

    nix = let
      users = ["root" "tomas"];
    in {
      package = cfg.package;

      settings = {
        experimental-features = "nix-command flakes";
        http-connections = 50;
        warn-dirty = false;
        log-lines = 50;

        # Large builds apparently fail due to an issue with darwin:
        # https://github.com/NixOS/nix/issues/4119
        sandbox = false;

        # This appears to break on darwin
        # https://github.com/NixOS/nix/issues/7273
        auto-optimise-store = true;

        allow-import-from-derivation = true;

        trusted-users = users;
        allowed-users = users;

        # NOTE: This configuration is generated by nix-installer so I'm adding it here in
        # case it becomes important.
        extra-nix-path = "nixpkgs=flake:nixpkgs";
        build-users-group = "nixbld";
      };
      # // (lib.optionalAttrs config.plusultra.tools.direnv.enable {
      #   keep-outputs = true;
      #   keep-derivations = true;
      # });

      gc = {
        automatic = true;
        interval = {Day = 1;};
        options = "--delete-older-than 14d";
        user = "tomas";
      };

      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
