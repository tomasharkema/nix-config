{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.traits.server.headless.enable {
    boot.initrd = {
      systemd.emergencyAccess = "abcdef";

      network = {
        enable = true;

        ssh = {
          enable = true;
          hostKeys = [
            "/etc/secrets/initrd/ssh_host_rsa_key"
            "/etc/secrets/initrd/ssh_host_ed25519_key"
          ];
        };
        # flushBeforeStage2 = true;
      };
    };
  };
}
