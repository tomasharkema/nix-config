{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.traits.server.headless.enable {
    systemd.sysupdate = {enable = true;};

    boot.initrd = {
      systemd.emergencyAccess = "abcdef";

      network = {
        enable = true;
        ssh.enable = true;
      };
    };
  };
}
