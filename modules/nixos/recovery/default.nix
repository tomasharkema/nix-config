{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; {
  config = let
    efi = config.boot.loader.efi;
    nixosDir = "/EFI/nixos";
    entries = {
      "netbootxyz.conf" = ''
        title  netboot.xyz
        efi    /efi/netbootxyz/netboot.xyz.efi
        sort-key netbootxyz
      '';
    };
    bootMountPoint = efi.efiSysMountPoint;
  in {
    system.activationScripts = {
      recovery.text = ''
        empty_file=$(${pkgs.coreutils}/bin/mktemp)

        RAMDISK="${inputs.self.nixosConfigurations.installer-netboot-x86.config.system.build.netbootRamdisk}"
        IPXE="${inputs.self.nixosConfigurations.installer-netboot-x86.config.system.build.netbootIpxeScript}"

        echo $RAMDISK $IPXE

        ${pkgs.coreutils}/bin/install -D "${pkgs.netbootxyz-efi}" "${bootMountPoint}/EFI/netbootxyz/netboot.xyz.efi"

        ${concatStrings (mapAttrsToList (n: v: ''
            ${pkgs.coreutils}/bin/install -Dp "${pkgs.writeText n v}" "${bootMountPoint}/loader/entries/"${escapeShellArg n}
            ${pkgs.coreutils}/bin/install -D $empty_file "${bootMountPoint}/${nixosDir}/.extra-files/loader/entries/"${escapeShellArg n}
          '')
          entries)}

      '';
    };
  };
}
