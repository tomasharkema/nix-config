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
          extraOptions =
            if stdenvNoCC.isDarwin
            then {
              "IdentityAgent" = "/Users/tomas/.1password/agent.sock";
            }
            else {
              "IdentityAgent" = "/home/tomas/.1password/agent.sock";
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
