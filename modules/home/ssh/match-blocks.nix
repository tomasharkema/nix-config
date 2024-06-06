{
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  machines = inputs.self.servers;
in
{
  config = {
    programs.ssh = {
      matchBlocks = mkMerge [
        (builtins.listToAttrs (
          map (machine: {
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
          }) machines
        ))

        (builtins.listToAttrs (
          map (machine: {
            name = "${machine}_*";
            value = {
              hostname = "${machine}";
              user = "tomas";
              forwardAgent = true;
              extraOptions = {
                RequestTTY = "yes";
                RemoteCommand = ''
                  zellij attach -c "ssh-''${%n}"
                '';
                # RemoteCommand = "tmux new -A -s \$\{\%n\}";
              };
            };
          }) machines
        ))
      ];
    };
  };
}
