{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs) stdenv;
in {
  imports = [./match-blocks.nix];
  config = {
    programs.ssh = {
      enable = true;

      matchBlocks = {
        "*" = {
          extraOptions = lib.mkIf stdenv.isDarwin {
            "IdentityAgent" = "/Users/tomas/.1password/agent.sock";
          };
        };
        wodan-wsl = {
          hostname = "192.168.1.46";
          user = "tomas";
          forwardAgent = true;
          extraOptions = {
            RequestTTY = "yes";
            HostKeyAlgorithms = "+ssh-rsa";
            # RemoteCommand = "tmux new -A -s \$\{\%n\}";
          };
        };
        silver-star = {
          hostname = "silver-star";
          user = "root";
          forwardAgent = true;
          extraOptions = {
            RequestTTY = "yes";
            # RemoteCommand = "tmux new -A -s \$\{\%n\}";
          };
        };
      };
    };
  };
}
