{
  pkgs,
  inputs,
  lib,
  ...
}: {
  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA4LeaUNIIlF1BL6FUDQ1/L3bSqh5TGlM8Jtr+vZ7iLE root@coopi";
    };

    hardware = {
      deviceTree = {
        enable = true;

        overlays = [
          {
            name = "ina219";
            dtsFile = ./i2c-ina219.dts;
          }
        ];
      };
    };

    networking = {
      hostName = "coopi";
      firewall.enable = false;
      networkmanager.enable = true;
    };

    zramSwap = {enable = true;};

    services.hardware.lcd.server = {
      # enable = true;
      extraConfig = ''
        Driver=glcdlib

        [glcdlib]
        Driver=framebuffer
        UseFT2=yes
        FontFile=${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf
      '';
    };

    traits = {
      hardware.raspberry.enable = true;
      low-power.enable = true;
      hardware.bluetooth.enable = true;
    };
  };
}
