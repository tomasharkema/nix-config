# https://cdn.electronic.us/products/usb-over-ethernet/linux/download/bullseye/usb_network_gate_bullseye_x64.deb

{ dpkg, lib, stdenv, fetchurl, autoPatchelfHook, pkg-config, gcc, libgcc, libcxx
, glibc, gcc-unwrapped, libGL, zlib, qt5, }:
stdenv.mkDerivation rec {
  name = "usb-over-ethernet";
  version = "1.0.0";

  src = if stdenv.isx86_64 then
    fetchurl {
      url =
        "https://cdn.electronic.us/products/usb-over-ethernet/linux/download/usb_network_gate_x64-2.deb";
      hash = "sha256-jvDpO4G/W0SLbRWNjKSYxQKSfJqn/1JnvBJvYxy0wv4=";
    }
  else
    fetchurl {
      url =
        "https://cdn.electronic.us/products/usb-over-ethernet/linux/download/buster/usb_network_gate_buster_x64.deb";
      hash = "sha256-jvDpO4G/W0SLbRWNjKSYxQKSfJqn/1JnvBJvYxy0wv4=";
    };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./usr/bin $out
    cp -r ./lib $out
    cp -r ./opt $out
    cp -r ./etc $out

    runHook postInstall
  '';

  nativeBuildInputs = [ autoPatchelfHook dpkg qt5.wrapQtAppsHook ];

  buildInputs = [ glibc gcc-unwrapped pkg-config gcc libgcc libcxx libGL zlib ];
}
