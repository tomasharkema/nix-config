{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    services.yubikey-agent.enable = true;

    security.pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };

    boot.initrd = {
      kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
      # luks.yubikeySupport = true;
    };

    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubikey-personalization
      yubico-piv-tool
      libfido2
    ];
    # programs.ssh.extraConfig = ''
    #   PKCS11Provider /run/current-system/sw/lib/libykcs11.so
    # '';
  };
}
