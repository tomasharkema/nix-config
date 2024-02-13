{pkgs, lib, config,...}:{
  config = {
boot.initrd.kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
boot.initrd.luks.yubikeySupport = true;
  };
}