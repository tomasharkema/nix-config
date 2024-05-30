# https://cdn.electronic.us/products/usb-over-ethernet/linux/download/bullseye/usb_network_gate_bullseye_x64.deb

{ dpkg, lib, stdenv, fetchurl, autoPatchelfHook, pkg-config, gcc, libgcc, libcxx
, glibc, gcc-unwrapped, libGL, zlib, qt5, makeWrapper, openssl_1_1
, linuxPackages, kernel ? linuxPackages.kernel, kmod, tree, }:
stdenv.mkDerivation rec {
  name = "usb-over-ethernet";
  version = "1.0.0";

  src = if stdenv.isx86_64 then
    fetchurl {
      url =
        "https://cdn.electronic.us/products/usb-over-ethernet/linux/download/usb_network_gate_x64-2.deb";
      hash = "sha256-kTgnLbe4UiIJw1VyFnWHzb/20lFsRuyfHs19JfjM5pA=";
    }
  else
    fetchurl {
      url =
        "https://cdn.electronic.us/products/usb-over-ethernet/linux/download/buster/usb_network_gate_buster_x64.deb";
      hash = "sha256-jvDpO4G/W0SLbRWNjKSYxQKSfJqn/1JnvBJvYxy0wv4=";
    };

  dontConfigure = true;
  dontBuild = true;

  # postUnpack = ''
  #   pwd
  #   cd root/opt/ElectronicTeam/eveusb/module
  #   sourceRoot="$(pwd -P)"
  # '';

  # makeFlags = [
  #   "KERNELRELEASE=${kernel.modDirVersion}" # 3
  #   "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # 4
  #   "INSTALL_MOD_PATH=$(out)" # 5
  # ];
  # makeFlags = kernel.makeFlags ++ [
  #   # "-C"
  #   "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  #   "M=$(sourceRoot)"
  # ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./opt/ElectronicTeam/eveusb/bin $out
    cp -r ./etc $out

    mkdir $out/lib
    cp -r ./opt/ElectronicTeam/eveusb/lib/libeveusb* $out/lib
    cp -r ./opt/ElectronicTeam/eveusb/lib/libboost* $out/lib

    mkdir -p $out/share/applications
    cp -r ./opt/ElectronicTeam/eveusb/desktop/ $out/share/applications/

    wrapProgram $out/bin/eveusb

    pwd .
    pwd $out
    ls $out

    runHook postInstall
  '';

  nativeBuildInputs = [ autoPatchelfHook dpkg qt5.wrapQtAppsHook makeWrapper ]
    ++ kernel.moduleBuildDependencies;

  buildInputs = [
    tree
    glibc
    gcc-unwrapped
    pkg-config
    gcc
    libgcc
    libcxx
    libGL
    zlib
    openssl_1_1
    qt5.qtbase
  ];
}
