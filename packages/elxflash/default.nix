{
  stdenv,
  pkgs,
  fetchurl,
  rpm,
  cpio,
  autoPatchelfHook,
  glibc,
  hwloc,
  ethtool,
  sysfsutils,
  libnl,
}:
stdenv.mkDerivation {
  pname = "elxflash";
  version = "10.0.878.0";

  src = fetchurl {
    url = "https://docs.broadcom.com/docs-and-downloads/oem/support/elx/rt10.0.2/10.0.878.0/Elxflash/offline/Linux/elxflashOffline_NIC_Only-linux-10.0.878.0-1.tgz";
    sha256 = "12gr2y8chszbsfdcydnlk7b62dlbnc9lml180fnrh384kzh98b9q";
  };
  nativeBuildInputs = [
    autoPatchelfHook
    rpm
    cpio
    hwloc
    glibc
    sysfsutils
    ethtool
    libnl
  ];

  buildInputs = [
    ethtool
    sysfsutils
    libnl
  ];

  installPhase = ''

    rpm2cpio x86_64/rhel-7/elxflashOffline-10.0.878.0-1.x86_64.rpm | cpio -idmv

    mkdir -p $out/bin
    # mkdir -p $out/share

    cp -vr ./usr/sbin/linlpcfg/* $out/bin
    # cp -r ./usr/sbin/linlpcfg/firmware $out/share/
    # cp ./usr/sbin/linlpcfg/fwmatrix.txt $out/share/fwmatrix.txt
  '';
}
