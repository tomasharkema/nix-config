{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs) stdenvNoCC;
  machines = ["blue-fire" "arthur" "enzian" "baaa-express" "pegasus" "hyperv-nixos"];
in {
  config = {
    programs.ssh = {
      matchBlocks = lib.mkMerge [
        (builtins.listToAttrs (map
          (machine: {
            name = "${machine}";
            value = {
              hostname = "${machine}";
              user = "tomas";
              forwardAgent = true;
              # extraOptions = {
              #   RequestTTY = "yes";
              #   RemoteCommand = "tmux new -A -s \$\{\%n\}";
              # };
            };
          })
          machines))

        (builtins.listToAttrs (map
          (machine: {
            name = "${machine}-*";
            value = {
              hostname = "${machine}";
              user = "tomas";
              forwardAgent = true;
              extraOptions = {
                RequestTTY = "yes";
                RemoteCommand = "tmux new -A -s \$\{\%n\}";
              };
            };
          })
          machines))
      ];
    };
  };
}
