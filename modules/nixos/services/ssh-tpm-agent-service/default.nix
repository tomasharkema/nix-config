{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.ssh-tpm-agent;
in {
  options.services.ssh-tpm-agent = {
    enable = mkEnableOption "ssh-tpm-agent";

    package = mkOption {
      default = pkgs.ssh-tpm-agent;
    };
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      # SSH_AUTH_SOCK = "/run/user/1000/ssh-tpm-agent.sock";
    };

    environment.systemPackages = [cfg.package];
    systemd = {
      services = {
        ssh-tpm-agent = {
          enable = true;
          wants = [
            "ssh-tpm-genkeys.service"
          ];
          after = [
            "ssh-tpm-genkeys.service"
            "network.target"
            "sshd.target"
          ];
          requires = ["ssh-tpm-agent.socket"];

          description = "ssh-tpm-agent service";
          # documentation = ''
          #   man:ssh-agent(1) man:ssh-add(1) man:ssh(1)
          # '';

          unitConfig = {
            ConditionEnvironment = "!SSH_AGENT_PID";
          };

          serviceConfig = {
            ExecStart = "${cfg.package}/bin/ssh-tpm-agent --key-dir /etc/ssh";
            PassEnvironment = "SSH_AGENT_PID";
            KillMode = "process";
            Restart = "always";
          };
        };

        ssh-tpm-genkeys = {
          enable = true;

          description = "SSH TPM Key Generation";

          unitConfig = {
            ConditionPathExists = [
              "|!/etc/ssh/ssh_tpm_host_ecdsa_key.tpm"
              "|!/etc/ssh/ssh_tpm_host_ecdsa_key.pub"
              "|!/etc/ssh/ssh_tpm_host_rsa_key.tpm"
              "|!/etc/ssh/ssh_tpm_host_rsa_key.pub"
            ];
          };

          serviceConfig = {
            ExecStart = "${cfg.package}/bin/ssh-tpm-keygen -A";
            Type = "oneshot";
            RemainAfterExit = "yes";
          };
        };
      };

      sockets = {
        ssh-tpm-agent = {
          enable = true;

          description = "SSH TPM agent socket";
          # documentation = ''
          #   man:ssh-agent(1) man:ssh-add(1) man:ssh(1)
          # '';

          socketConfig = {
            ListenStream = "/var/tmp/ssh-tpm-agent.sock";
            SocketMode = 0600;
            Service = "ssh-tpm-agent.service";
          };
        };
      };

      user = {
        services.ssh-tpm-agent = {
          enable = true;

          description = "ssh-tpm-agent service";
          # documentation = ''
          #   man:ssh-agent(1) man:ssh-add(1) man:ssh(1)
          # '';

          unitConfig = {
            ConditionEnvironment = "!SSH_AGENT_PID";
            Requires = "ssh-tpm-agent.socket";
          };
          serviceConfig = {
            Environment = "SSH_AUTH_SOCK=%t/ssh-tpm-agent.sock";
            ExecStart = "${cfg.package}/bin/ssh-tpm-agent";
            PassEnvironment = "SSH_AGENT_PID";
            SuccessExitStatus = 2;
            Type = "simple";
          };
          # Install.Also = "ssh-agent.socket";
        };
        sockets.ssh-tpm-agent = {
          enable = true;

          unitConfig = {
            Description = "SSH TPM agent socket";
            # Documentation = "man:ssh-agent(1) man:ssh-add(1) man:ssh(1)";
          };
          socketConfig = {
            ListenStream = "%t/ssh-tpm-agent.sock";
            SocketMode = 0600;
            Service = "ssh-tpm-agent.service";
          };
          # Install.WantedBy = "sockets.target";
        };
      };
    };
  };
}
