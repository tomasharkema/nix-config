{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    security.pam = {
      # p11.enable = true;
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
        cockpit.u2fAuth = true;
      };
    };

    # programs = {
    #   yubikey-touch-detector.enable = true;
    #   ssh.extraConfig = ''
    #     PKCS11Provider ${pkgs.yubico-piv-tool}/lib/libykcs11.so
    #   '';
    # };

    services = {
      pcscd.enable = true;
      yubikey-agent.enable = true;
      udev.packages = with pkgs; [
        yubioath-flutter
        yubikey-agent
        yubikey-manager
        yubikey-manager-qt
        yubikey-personalization
        yubikey-personalization-gui
        yubico-piv-tool
      ];
    };

    boot.initrd = {
      kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
      # luks.yubikeySupport = true;
    };

    environment.systemPackages = with pkgs; [
      age-plugin-yubikey
      libfido2
      # opensc
      # pcsctools
      yubico-piv-tool
      yubioath-flutter
      yubikey-agent
      yubikey-manager
      yubikey-manager-qt
      yubikey-personalization
      yubikey-personalization-gui
      # yubikey-touch-detector
    ];
  };
}
