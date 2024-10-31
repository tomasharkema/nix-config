{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    security.pam = {
      # yubico = {
      # enable = true;
      #   debug = true;
      # };

      p11.enable = true;

      services = {
        # login.u2fAuth = true;
        # sudo.u2fAuth = true;
        #   ssh.u2fAuth = true;
        #   userpass.u2fAuth = true;

        # login.sssdStrictAccess = true;
        login.enableGnomeKeyring = true;
        # xscreensaver.sssdStrictAccess = true;
        # sudo.sssdStrictAccess = true;
      };
    };

    hardware.gpgSmartcards.enable = true;

    programs = {
      yubikey-touch-detector.enable = true;
      # ssh.extraConfig = ''
      #   PKCS11Provider ${pkgs.yubico-piv-tool}/lib/libykcs11.so
      # '';

      # gnupg.agent = {
      #   enable = true;
      #   enableBrowserSocket = true;
      # };
    };

    home-manager.users.tomas = {
      # services.gpg-agent = {
      #   enable = true;
      #   enableZshIntegration = true;
      # };

      # programs.gpg.scdaemonSettings = {
      #   disable-ccid = true;
      # };

      # programs.gpg = {
      # enable = true;
      # scdaemonSettings = {
      #   reader-port = "Yubico Yubi";

      # disable-ccid = true;
      # };
      # };
    };

    # security.polkit.extraConfig = ''
    #   polkit.addRule(function(action, subject) {
    #     if (subject.isInGroup("ykusers")) {
    #       return polkit.Result.YES;
    #     }
    #   })
    # '';

    services = {
      # pcscd = {
      #   enable = true;
      #   plugins = [pkgs.yubikey-personalization];
      # };
      yubikey-agent.enable = config.gui.enable;

      udev = {
        packages = [pkgs.yubikey-personalization];
        # extraRules = ''
        #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev"
        # '';
      };
    };

    boot.initrd = {
      kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
      # luks.yubikeySupport = true;
    };

    users.groups = {"plugdev" = {};};

    environment.systemPackages = with pkgs; [
      p11-kit
      # pcsc-tools
      age-plugin-yubikey
      libfido2
      yubico-piv-tool
      yubioath-flutter
      # yubikey-agent
      yubikey-manager
      yubikey-manager-qt
      yubikey-personalization
      yubikey-personalization-gui
      # opensc
    ];
  };
}
