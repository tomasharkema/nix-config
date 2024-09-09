{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  kernel ? pkgs.linuxPackages_latest.kernel,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "xmm7360-pci";
  version = "2020-08-02";

  src = fetchFromGitHub {
    owner = "xmm7360";
    repo = "xmm7360-pci";
    rev = "a8ff2c6ceee84cbe74df8a78cfaa5a016d362ed4";
    sha256 = "sha256-wwm9ELALiJrC54azyJ95Rm3pcGLYzhxEe9mcCUvSVKk=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

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
  '';

  meta = {
    description = "PCI driver for Fibocom L850-GL modem based on Intel XMM7360 modem";
    homepage = "https://github.com/xmm7360/xmm7360-pci/";
    license = lib.licenses.free;
    platforms = ["x86_64-linux"];
  };
}
