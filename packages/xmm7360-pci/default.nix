{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  kernel ? pkgs.linuxPackages_latest.kernel,
  python3,
  fetchpatch,
}: let
  settingsFile = pkgs.writeText "xmm7360.ini" ''
    # driver config
    apn=multimedia.lebara.nl

    #ip-fetch-timeout=1
    nodefaultroute=True
    #metric=1000

    # uncomment to not add DNS values to /etc/resolv.conf
    noresolv=True

    # used to activate NetworkManager integration
    #dbus=True

    # Setup script config
    # BIN_DIR=/usr/local/bin
  '';
in
  stdenv.mkDerivation rec {
    pname = "xmm7360-pci";
    version = "2024-02-24-${kernel.version}";

    src = fetchFromGitHub {
      owner = "xmm7360";
      repo = "xmm7360-pci";
      rev = "a8ff2c6ceee84cbe74df8a78cfaa5a016d362ed4";
      sha256 = "sha256-wwm9ELALiJrC54azyJ95Rm3pcGLYzhxEe9mcCUvSVKk=";
    };

    nativeBuildInputs = kernel.moduleBuildDependencies;
    patches = [
      (fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/xmm7360/xmm7360-pci/pull/220.patch";
        sha256 = "sha256-zIx9tkPo9LFgaOVSyEQBNIgVY2QwdYpM/tw6/ifiy1A=";
      })
    ];
    # --replace "/dev/xmm0/rpc" "/dev/wwan0rpc0"
    prePatch = ''
      substituteInPlace rpc/open_xdatachannel.py --replace "#!/usr/bin/env python3"  "#!${
        (python3.withPackages
          (ps: [ps.ConfigArgParse ps.pyroute2 ps.dbus-python]))
      }/bin/python3"
    '';

    makeFlags = ["KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"];

    installPhase = ''
      mkdir -p $out/bin/
      install -D xmm7360.ko $out/lib/modules/${kernel.modDirVersion}/misc/xmm7360.ko
      cp rpc/* $out/bin/

      cp scripts/lte.sh $out/bin/lte
      chmod +x $out/bin/lte

      substituteInPlace $out/bin/lte --replace 'CONF_FILE=$SCRIPT_DIR/../xmm7360.ini' "CONF_FILE=${settingsFile}"
    '';

    meta = {
      description = "PCI driver for Fibocom L850-GL modem based on Intel XMM7360 modem";
      homepage = "https://github.com/xmm7360/xmm7360-pci/";
      license = lib.licenses.free;
      platforms = ["x86_64-linux"];
    };
  }
