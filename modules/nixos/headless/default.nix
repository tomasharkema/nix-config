{config,lib,...}: {
  config = lib.mkIf false{
    services = {
      # self-deploy = {};
    };

    boot = {
      kernelParams = ["panic=1" "boot.panic_on_fail" "vga=0x317" "nomodeset"];
      loader.grub.splashImage = null;
    };

    systemd.enableEmergencyMode = false;
  };
}
