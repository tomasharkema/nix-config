{ lib, ... }:
let
  machines = [ "supermicro" "cfserve" "enceladus" "raspbii3" "raspbii4" "hyperv-nixos" ];
in
lib.mkMerge [
  (builtins.listToAttrs (map
    (machine: {
      name = "${machine}";
      value = {
        hostname = "${machine}";
        user = "tomas";
        forwardAgent = true;
        extraOptions = {
          RequestTTY = "yes";
          # RemoteCommand = "tmux new -A -s \$\{\%n\}";
        };
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
]
