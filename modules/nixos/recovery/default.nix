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
        efi    /efi/recovery/recovery.efi
        sort-key nixosrecovery
      '';
    };
    bootMountPoint = efi.efiSysMountPoint;

    configuration = config.boot.recovery.configuration;
    configurationBuild = configuration.config.system.build;
    toplevel = configurationBuild.toplevel;
    configurationHash = builtins.hashString "sha256" "${toplevel.drvPath}${config.system.build.recoveryImage.drvPath}";
    configurationHashFile = pkgs.writeText "configuration-hash" "${configurationHash}";

    ramdisk = configurationBuild.netbootRamdisk;
    installer = toplevel;
    kernelVersion = configurationBuild.kernel.version;

    hostnameFile = pkgs.writeText "hostname" "${config.networking.hostName}";

    splash = pkgs.stdenvNoCC.mkDerivation {
      name = "splash.xpm.gz";
      src = ./nix-snowflake-rainbow-svg.xpm;

      dontUnpack = true;

      installPhase = ''
        cat $src | gzip -9 > $out
      '';
    };
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

      installPhase = ''
        ukify build \
          --linux="${installer}/kernel" \
          --initrd="${ramdisk}/initrd" \
          --uname="${kernelVersion}" \
          --os-release="${installer}/etc/os-release" \
          --cmdline="debug init=${installer}/init" \
          --splash="${splash}" \
          --measure \
          --output=$out
      '';
    };

    system.activationScripts = {
      recovery.text = ''

        CONFIGURATION_HASH_FILE="${bootMountPoint}/EFI/recovery/configuration.hash"
        NEW_HASH="$(cat ${configurationHashFile})"

        if [ -f "$CONFIGURATION_HASH_FILE" ]; then
          CURRENT_HASH="$(cat $CONFIGURATION_HASH_FILE)"
          echo "check hash: OLD: $CURRENT_HASH NEW: $NEW_HASH"

          if [ "$NEW_HASH" = "$CURRENT_HASH" ]; then
            echo "HASH $(cat $CONFIGURATION_HASH_FILE) ALREADY INSTALLED"
            exit 0
          fi
        fi

        empty_file=$(${pkgs.coreutils}/bin/mktemp)

        ${pkgs.coreutils}/bin/install -D "${config.system.build.recoveryImage}" "${bootMountPoint}/EFI/recovery/recovery.efi"
        ${pkgs.sbctl}/bin/sbctl sign -s "${bootMountPoint}/EFI/recovery/recovery.efi"

        BOOT_ENTRY=$(${pkgs.efibootmgr}/bin/efibootmgr --verbose | ${pkgs.gnugrep}/bin/grep NixosRecovery)
        BOOT_ENTRY_CODE="$?"

        if [ $BOOT_ENTRY_CODE -gt 0 ]; then
          BOOT_PART="$(${pkgs.util-linux}/bin/findmnt -J "${bootMountPoint}" | ${pkgs.jq}/bin/jq ".filesystems[0].source" -r)"
          DEVICE="/dev/$(${pkgs.util-linux}/bin/lsblk -no pkname $BOOT_PART)"
          PARTN="$(${pkgs.util-linux}/bin/lsblk -no PARTN $BOOT_PART)"
          ${pkgs.efibootmgr}/bin/efibootmgr -c -d $DEVICE -p $PARTN -L NixosRecovery -l '\EFI\recovery\recovery.efi'
        fi

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
