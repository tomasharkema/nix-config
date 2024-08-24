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
      default = inputs.self.installer."${pkgs.system}".netboot;
    };

    sign = mkEnableOption "sign";

    install = mkEnableOption "install";

    netboot.enable = mkEnableOption "netboot";
  };

  config = let
    cfg = config.boot.recovery;
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

    configuration = cfg.configuration;
    configurationBuild = configuration.config.system.build;
    toplevel = configurationBuild.toplevel;

    ramdisk = configurationBuild.netbootRamdisk;
    installer = toplevel;
    kernelVersion = configurationBuild.kernel.version;

    configFile = pkgs.writeText "config.json" (builtins.toJSON {
      hostname = "${config.networking.hostName}";
      imageDrv = "${config.system.build.recoveryImage.drvPath}";
      sign = cfg.sign;
      inherit kernelVersion;
    });
  in
    mkIf cfg.enable {
      system.build.splash = pkgs.stdenvNoCC.mkDerivation {
        name = "splash.xpm.gz";
        src = ./nix-snowflake-rainbow-svg.xpm;

        dontUnpack = true;

        installPhase = ''
          cat $src | gzip -9 > $out
        '';
      };

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
            --splash="${config.system.build.splash}" \
            --measure \
            --output=$out
        '';
      };

      environment.systemPackages = [pkgs.recoveryctl];

      system.activationScripts = mkIf cfg.install {
        recovery.text = let
          recov = pkgs.writeShellScript "recovery.sh" ''


            if ! ${pkgs.diffutils}/bin/diff "${configFile}" "${bootMountPoint}/EFI/recovery/config.json" > /dev/null 2>&1; then
              ${pkgs.coreutils}/bin/install -D "${config.system.build.recoveryImage}" "${bootMountPoint}/EFI/recovery/recovery.efi"
              ${optionalString cfg.sign ''
              ${pkgs.sbctl}/bin/sbctl sign -s "${bootMountPoint}/EFI/recovery/recovery.efi"
            ''}

              ${pkgs.coreutils}/bin/install -D "${configFile}" "${bootMountPoint}/EFI/recovery/config.json"

              ${pkgs.coreutils}/bin/install -D "${pkgs.netbootxyz-efi}" "${bootMountPoint}/EFI/netbootxyz/netboot.xyz.efi"

              ${optionalString cfg.sign ''
              ${pkgs.sbctl}/bin/sbctl sign -s "${bootMountPoint}/EFI/netbootxyz/netboot.xyz.efi"
            ''}
            fi

            empty_file=$(${pkgs.coreutils}/bin/mktemp)
            ${concatStrings (mapAttrsToList (n: v: let
                src = "${pkgs.writeText n v}";
                dest = "${bootMountPoint}/loader/entries/${escapeShellArg n}";
              in ''
                if ! ${pkgs.diffutils}/bin/diff "${src}" "${dest}" > /dev/null 2>&1; then

                  ${pkgs.coreutils}/bin/install -Dp "${src}" "${dest}"
                  ${pkgs.coreutils}/bin/install -D $empty_file "${bootMountPoint}/${nixosDir}/.extra-files/loader/entries/"${escapeShellArg n}

                fi
              '')
              entries)}

            BOOT_ENTRY=$(${pkgs.efibootmgr}/bin/efibootmgr --verbose | ${pkgs.gnugrep}/bin/grep NixosRecovery)
            BOOT_ENTRY_CODE="$?"

            if [ $BOOT_ENTRY_CODE -gt 0 ]; then
              BOOT_PART="$(${pkgs.util-linux}/bin/findmnt -J "${bootMountPoint}" | ${pkgs.jq}/bin/jq ".filesystems[0].source" -r)"
              DEVICE="/dev/$(${pkgs.util-linux}/bin/lsblk -no pkname $BOOT_PART)"
              PARTN="$(${pkgs.util-linux}/bin/lsblk -no PARTN $BOOT_PART)"
              ${pkgs.efibootmgr}/bin/efibootmgr -c --index 2 -d $DEVICE -p $PARTN -L NixosRecovery -l '\EFI\recovery\recovery.efi'
            fi

          '';
        in "${recov}";
      };
    };
}
# if ! ${pkgs.diffutils}/bin/diff ${cfg.certificate} /etc/ipa/ca.crt > /dev/null 2>&1; then
#   rm -f /etc/ipa/ca.crt
#   cp ${cfg.certificate} /etc/ipa/ca.crt
# fi

