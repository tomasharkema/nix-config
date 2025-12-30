{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  kernel ? pkgs.linuxPackages_latest.kernel,
  python3,
  fetchpatch,
}: let
  py = python3.withPackages (ps: [
    ps.configargparse
    ps.pyroute2
    ps.dbus-python
    ps.pytap2
  ]);
in
  stdenv.mkDerivation rec {
    pname = "xmm7360-pci";
    version = "2025-10-31-${kernel.version}";

    # src = fetchFromGitHub {
    #   owner = "xmm7360";
    #   repo = "xmm7360-pci";
    #   rev = "a8ff2c6ceee84cbe74df8a78cfaa5a016d362ed4";
    #   sha256 = "sha256-wwm9ELALiJrC54azyJ95Rm3pcGLYzhxEe9mcCUvSVKk=";
    # };
    src = fetchFromGitHub {
      owner = "SimPilotAdamT";
      repo = "xmm7360-pci-SPAT";
      rev = "master";
      sha256 = "sha256-T+yJqHzf5gj8r/z4MrN+ZBDr2kfUNEVZEf3eFvGcJKg=";
    };

    nativeBuildInputs = kernel.moduleBuildDependencies;
    patches = [
      # (fetchpatch {
      #   url = "https://patch-diff.githubusercontent.com/raw/xmm7360/xmm7360-pci/pull/220.patch";
      #   sha256 = "sha256-zIx9tkPo9LFgaOVSyEQBNIgVY2QwdYpM/tw6/ifiy1A=";
      # })
      # (fetchpatch {
      #   url = "https://raw.githubusercontent.com/chaotic-aur/pkgbuild-xmm7360-pci-git/refs/heads/master/nodbus-exit-code.patch";
      #   sha256 = "sha256-aOUaPskcHjZzjfy/es33va+GJqwLDH7NRdsh0rpp+Do=";
      # })
      # (fetchpatch {
      #   url = "https://raw.githubusercontent.com/chaotic-aur/pkgbuild-xmm7360-pci-git/refs/heads/master/dns-priority.patch";
      #   sha256 = "sha256-/oSuUn6INq0uo2wmVieRo5CWgjTLYO51mqinBEbcanA=";
      # })
      #
      # adds netstats!
      # (fetchpatch {
      #   url = "https://patch-diff.githubusercontent.com/raw/xmm7360/xmm7360-pci/pull/165.patch";
      #   sha256 = "sha256-VmCqfyxGAiuJq9WIDF5NFIKkEnPHJlsjyaYXfv39oV8=";
      # })
      ./linux-6.15.patch
    ];

    prePatch = ''
      substituteInPlace rpc/open_xdatachannel.py \
        --replace-fail "#!/usr/bin/env python3" "#!${py}/bin/python3"

      substituteInPlace rpc/mux.py \
        --replace-fail "#!/usr/bin/env python" "#!${py}/bin/python3"
    '';

    makeFlags = ["KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"];

    postBuild = ''
      make -C rpc
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin/
      install -D xmm7360.ko $out/lib/modules/${kernel.modDirVersion}/extra/xmm7360.ko
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
