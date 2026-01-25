{
  pkgs,
  inputs,
  lib,
  ...
}: {
  config = {
    age.rekey = {
      #hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOErOLMK4TJkWUgSQTHX5u08hxlxw3tajR6K1ckcVmei root@coopi";
    };

    hardware = {
      deviceTree = {
        enable = true;

        # overlays = [
        #   {
        #     name = "ina219";
        #     dtsFile = ./i2c-ina219.dts;
        #   }
        # ];
      };
    };

    networking = {
      hostName = "copi2";
      firewall.enable = false;
      networkmanager.enable = true;
    };

    boot = {
      initrd = {
        availableKernelModules = [
          "usbhid"
          "usb-storage"
          "vc4"
        ];

        systemd.tpm2.enable = false;
      };
      # kernelPackages = lib.mkForce pkgs.linuxPackages_rpi02w;

      kernelParams = [
        "rootwait"
        "elevator=deadline"
      ];
    };

    zramSwap = {enable = true;};

    # services.hardware.lcd.server = {
    #   # enable = true;
    #   extraConfig = ''
    #     Driver=glcdlib

    #     [glcdlib]
    #     Driver=framebuffer
    #     UseFT2=yes
    #     FontFile=${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf
    #   '';
    # };

    traits = {
      hardware.raspberry.enable = true;
      low-power.enable = true;
      hardware.bluetooth.enable = true;
    };
  };
}
