{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.remote-unlock;
in {
  options.traits = {
    hardware.remote-unlock = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.remote-unlock-keys.text = ''
      mkdir -p /boot/secrets
      ssh-keygen -t ecdsa -N "" -f /boot/secrets/ssh_host_ecdsa_key
      ssh-keygen -t ed25519 -N "" -f /boot/secrets/ssh_host_ed25519_key
      ssh-keygen -t rsa -N "" -f /boot/secrets/ssh_host_rsa_key
    '';

    boot = {
      initrd = {
        systemd.users.root.shell = "/bin/systemd-tty-ask-password-agent";

        availableKernelModules = ["e1000e" "r8169"];

        network = {
          enable = true;
          ssh = {
            enable = true;
            port = 22222;

            authorizedKeys = config.user.keys;
            hostKeys = [
              "/boot/secrets/ssh_host_ed25519_key"
              "/boot/secrets/ssh_host_rsa_key"
              "/boot/secrets/ssh_host_ecdsa_key"
            ];
          };
        };
      };
      kernelParams = ["ip=dhcp"];
    };
  };
}
