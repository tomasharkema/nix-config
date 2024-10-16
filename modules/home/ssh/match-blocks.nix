{
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}: let
  machines = inputs.self.machines.excludingSelf osConfig;
in {
  config = {
    programs.ssh = {
      matchBlocks = lib.mkMerge [
        (builtins.listToAttrs (
          map (machine: {
            name = "${machine}";
            value = {
              hostname = "${machine}";
              user = "tomas";
              forwardAgent = true;
              extraOptions = {
                # ProxyCommand = lib.mkIf pkgs.stdenv.isLinux "${pkgs.sssd}/bin/sss_ssh_knownhostsproxy -p %p %h";
                # GlobalKnownHostsFile = lib.mkIf pkgs.stdenv.isLinux "/var/lib/sss/pubconf/known_hosts";
                RequestTTY = "yes";
                # RemoteCommand = "zellij attach -c \"ssh-\$\{\%n\}\"";
                # RemoteCommand = "tmux new -A -s \$\{\%n\}";
              };
            };
          })
          machines
        ))
        (builtins.listToAttrs (
          map (machine: {
            name = "${machine}_*";
            value = {
              hostname = "${machine}";
              user = "tomas";
              forwardAgent = true;
              extraOptions = {
                # ProxyCommand = lib.mkIf pkgs.stdenv.isLinux "${pkgs.sssd}/bin/sss_ssh_knownhostsproxy -p %p %h";
                # GlobalKnownHostsFile = lib.mkIf pkgs.stdenv.isLinux "/var/lib/sss/pubconf/known_hosts";
                RequestTTY = "yes";
                RemoteCommand = ''
                  zellij attach -c "ssh-''${%n}"
                '';
                # RemoteCommand = "tmux new -A -s \$\{\%n\}";
              };
            };
          })
          machines
        ))
      ];
    };
  };
}
