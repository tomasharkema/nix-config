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
      "recovery.conf" = ''
        title  NixOS Recovery
        efi    /efi/recovery.efi
        sort-key nixosrecovery
      '';
    };
    bootMountPoint = efi.efiSysMountPoint;

    ramdisk = inputs.self.nixosConfigurations.installer-netboot-x86.config.system.build.netbootRamdisk;
    # script = inputs.self.nixosConfigurations.installer-netboot-x86.config.system.build.netbootIpxeScript;
    # kernel = inputs.self.nixosConfigurations.installer-netboot-x86.config.system.build.kexecTree;
    installer = inputs.self.nixosConfigurations.installer-netboot-x86.config.system.build.toplevel;
  in {
    # ${lib.getExe efibootmgr} --create --disk /dev/sdb --part 1 --label "Debian" --loader EFI/Debian/vmlinuz --unicode "root=UUID=$UUID ro initrd=EFI\\Debian\\initrd.img"

    # ISO="${inputs.self.nixosConfigurations.installer-x86.config.system.build.isoImage}"
    # RAMDISK="${inputs.self.nixosConfigurations.installer-x86.config.system.build.initialRamdisk}"
    # KERNEL="${inputs.self.nixosConfigurations.installer-x86.config.system.build.kernel}/bzImage"

    # set +e
    # efibootmgr -c -d "@efiDisk@" -g -l $(echo $kernel | sed 's|@efiSysMountPoint@||' | sed 's|/|\\|g') -L "NixOS $generation Generation" -p "@efiPartition@" \
    #   -u systemConfig=$(readlink -f $path) init=$(readlink -f $path/init) initrd=$(echo $initrd | sed 's|@efiSysMountPoint@||' | sed 's|/|\\|g') $(cat $path/kernel-params) > /dev/null 2>&1
    # set -e
    # ${pkgs.efibootmgr}/bin/efibootmgr --create --disk /dev/sdb --part 1 --label "Debian" --loader EFI/Debian/vmlinuz --unicode "root=UUID=$UUID ro initrd=EFI\\Recovery\\initrd.img"
    #    ${pkgs.efibootmgr}/bin/efibootmgr -c -d /dev/nvme0n1 -p 2 -L NixosRecovery -l '\EFI\recovery.efi'

    system.activationScripts = {
      recovery.text = ''
        empty_file=$(${pkgs.coreutils}/bin/mktemp)
        tmp_dir=$(${pkgs.coreutils}/bin/mktemp -d)

        RAMDISK="${ramdisk}"
        KERNEL="${installer}/kernel"
        INITS="${installer}/init"

        echo $SCRIPT $RAMDISK $KERNEL $tmp_dir

        ${pkgs.systemdUkify}/bin/ukify build --linux=$KERNEL --initrd=$RAMDISK/initrd \
          --cmdline="init=$INITS" \
          --output=$tmp_dir/recovery.efi

        ${pkgs.coreutils}/bin/install -D "$tmp_dir/recovery.efi" "${bootMountPoint}/EFI/recovery.efi"
        ${pkgs.sbctl}/bin/sbctl sign -s "${bootMountPoint}/EFI/recovery.efi"

        ${pkgs.coreutils}/bin/install -D "${pkgs.netbootxyz-efi}" "${bootMountPoint}/EFI/netbootxyz/netboot.xyz.efi"

        ${pkgs.sbctl}/bin/sbctl sign -s "${bootMountPoint}/EFI/netbootxyz/netboot.xyz.efi"

        ${concatStrings (mapAttrsToList (n: v: ''
            ${pkgs.coreutils}/bin/install -Dp "${pkgs.writeText n v}" "${bootMountPoint}/loader/entries/"${escapeShellArg n}
            ${pkgs.coreutils}/bin/install -D $empty_file "${bootMountPoint}/${nixosDir}/.extra-files/loader/entries/"${escapeShellArg n}
          '')
          entries)}

      '';
    };
  };
}
