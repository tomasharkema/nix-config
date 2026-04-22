{
  stdenv,
  libreboot,
  mrc,
  callPackage,
}: let
  mkCoreboot = callPackage ./mkCoreboot.nix {};
  me = callPackage ./me.nix {};
  config = stdenv.mkDerivation {
    name = "coreboot-config-t580";
    src = libreboot;
    dontBuild = true;
    installPhase = ''
      cp ${./config} $out
      chmod u+w $out

      echo 'CONFIG_GBE_BIN_PATH="${libreboot}/blobs/t580/gbe.bin"' >> $out
      echo 'CONFIG_IFD_BIN_PATH="${./ifd.bin}"' >> $out
      echo 'CONFIG_ME_BIN_PATH="${me}"' >> $out
    '';
  };
in
  mkCoreboot {
    name = "coreboot-t550";

    inherit config;
  }
