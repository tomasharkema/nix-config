{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs) stdenvNoCC;
in {
  imports = [./match-blocks.nix];
  config = {
    programs.ssh = {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "*" = {
          # extraOptions =
          #   if stdenvNoCC.isDarwin
          #   then {
          #     "IdentityAgent" = "/Users/tomas/.1password/agent.sock";
          #   }
          #   else {
          #     "IdentityAgent" = "/home/tomas/.1password/agent.sock";
          #   };
        };
        wodan-wsl = {
          # hostname = "192.168.1.46";
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
