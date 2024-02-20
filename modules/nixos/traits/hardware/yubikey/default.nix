{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    services.yubikey-agent.enable = true;

    # security.pam = {
    #   p11.enable = true;
    #   services = {
    #     login.u2fAuth = true;
    #     sudo.u2fAuth = true;
    #   };
    # };

    programs.yubikey-touch-detector.enable = true;
    services.pcscd.enable = true;

    boot.initrd = {
      kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
      # luks.yubikeySupport = true;
    };

    environment.systemPackages = with pkgs; [
      age-plugin-yubikey
      libfido2
      opensc
      # pcsclite
      pcsctools
      yubico-piv-tool
      yubikey-agent
      yubikey-manager
      yubikey-manager-qt
      yubikey-personalization
      yubikey-personalization-gui
      yubikey-touch-detector
      # yubioath-desktop
    ];
    # programs.ssh.extraConfig = ''
    #   PKCS11Provider /run/current-system/sw/lib/libykcs11.so
    # '';
  };
}
