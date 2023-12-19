{ lib, ... }:
let
  machines = [ "supermicro" "cfserve" "enceladus" "raspbii3" "raspbii4" "tower" "hyperv-nixos" ];

  valueFn = (machine: {
    hostname = "${machine}";
    user = "tomas";
    forwardAgent = true;
    extraOptions = {
      RequestTTY = "yes";
      RemoteCommand = "tmux new -A -s \$\{\%n\}";
    };
  });
in
lib.mkMerge [
  (builtins.listToAttrs (map
    (machine: {
      name = "${machine}";
      value = valueFn machine;
    })
    machines))

  (builtins.listToAttrs (map
    (machine: {
      name = "${machine}-*";
      value = valueFn machine;
    })
    machines))
]
