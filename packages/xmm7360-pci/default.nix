{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  kernel ? pkgs.linuxPackages_latest.kernel,
  python3,
  fetchpatch,
}:
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

  prePatch = let
    py = python3.withPackages (ps: [ps.ConfigArgParse ps.pyroute2 ps.dbus-python]);
  in ''
    substituteInPlace rpc/open_xdatachannel.py \
      --replace-fail "#!/usr/bin/env python3" "#!${py}/bin/python3"
  '';

  makeFlags = ["KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    install -D xmm7360.ko $out/lib/modules/${kernel.modDirVersion}/misc/xmm7360.ko
    cp rpc/* $out/bin/

    cp scripts/lte.sh $out/bin/lte
    chmod +x $out/bin/lte

    runHook postInstall
  '';

  meta = {
    description = "PCI driver for Fibocom L850-GL modem based on Intel XMM7360 modem";
    homepage = "https://github.com/xmm7360/xmm7360-pci/";
    license = lib.licenses.free;
    platforms = ["x86_64-linux"];
  };
}
