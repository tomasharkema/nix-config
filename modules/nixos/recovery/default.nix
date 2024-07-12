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
    # ${lib.getExe efibootmgr} --create --disk /dev/sdb --part 1 --label "Debian" --loader EFI/Debian/vmlinuz --unicode "root=UUID=$UUID ro initrd=EFI\\Debian\\initrd.img"

    system.activationScripts = {
      recovery.text = ''
        empty_file=$(${pkgs.coreutils}/bin/mktemp)

        RAMDISK="${inputs.self.nixosConfigurations.installer-x86.config.system.build.initialRamdisk}"
        KERNEL="${inputs.self.nixosConfigurations.installer-x86.config.system.build.kernel}/bzImage"

        echo $RAMDISK $KERNEL

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
