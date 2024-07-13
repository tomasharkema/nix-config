{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; {
  options.boot.recovery = {
    enable = mkEnableOption "enable recovery";

    configuration = mkOption {
      default = inputs.self.nixosConfigurations.installer-netboot-x86;
    };
  };

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

    configuration = config.boot.recovery.configuration;
    configurationBuild = configuration.config.system.build;
    toplevel = configurationBuild.toplevel;
    configurationHash = builtins.hashString "sha256" toplevel.drvPath;
    configurationHashFile = pkgs.writeText "configuration-hash" "${configurationHash}";

    ramdisk = configurationBuild.netbootRamdisk;
    installer = toplevel;
    kernelVersion = configurationBuild.kernel.version;

    hostnameFile = pkgs.writeText "hostname" "${config.networking.hostName}";
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

    system.build.recoveryImage = pkgs.stdenvNoCC.mkDerivation {
      name = "recovery.efi";
      src = installer;
      # version = "1.0.0";

      dontPatch = true;

      buildInputs = with pkgs; [systemdUkify];

      installPhase = builtins.trace "build uki for ${installer}" ''
        ukify build \
          --linux="${installer}/kernel" \
          --initrd="${ramdisk}/initrd" \
          --uname="${kernelVersion}" \
          --os-release="${installer}/etc/os-release" \
          --cmdline="debug init=${installer}/init" \
          --output=$out
      '';
    };

    system.activationScripts = {
      recovery.text = ''
        empty_file=$(${pkgs.coreutils}/bin/mktemp)

        ${pkgs.coreutils}/bin/install -D "${config.system.build.recoveryImage}" "${bootMountPoint}/EFI/recovery/recovery.efi"
        ${pkgs.sbctl}/bin/sbctl sign -s "${bootMountPoint}/EFI/recovery/recovery.efi"

        ${pkgs.coreutils}/bin/install -D "${hostnameFile}" "${bootMountPoint}/EFI/recovery/hostname"

        ${pkgs.coreutils}/bin/install -D "${configurationHashFile}" "${bootMountPoint}/EFI/recovery/configuration.hash"

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
