{
  lib,
  pkgs,
  ...
}: let
  machines = [
    "blue-fire"
    "arthur"
    "enzian"
    "baaa-express"
    "pegasus"
    "euro-mir"
    "euro-mir-2"
    "euro-mir-vm"
    "wodan"
    "silver-star-vm"
  ];
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
              extraOptions = {
                RequestTTY = "yes";
                # RemoteCommand = "zellij attach -c \"ssh-\$\{\%n\}\"";
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
                RemoteCommand = "zellij attach -c \"ssh-\$\{\%n\}\"";
                # RemoteCommand = "tmux new -A -s \$\{\%n\}";
              };
            };
          })
          machines))
      ];
    };
  };
}
