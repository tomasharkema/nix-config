# http://dell.archive.canonical.com/updates/pool/public/libf/libfprint-2-tod1-goodix/libfprint-2-tod1-goodix_0.0.6.orig.tar.gz
{
  stdenv,
  lib,
  libfprint-tod,
}:
stdenv.mkDerivation rec {
  pname = "libfprint-2-tod1-goodix";
  version = "0.0.6";

  src = fetchTarball {
    url = "http://dell.archive.canonical.com/updates/pool/public/libf/libfprint-2-tod1-goodix/libfprint-2-tod1-goodix_${version}.orig.tar.gz";
    sha256 = "sha256:1h0hk39chc7i5j2cxiv9h3dpgh7s7c3sjjb17sb8b7agbfdzy3h8";
  };
  # installPhase = ''
  #   cp -r . $out
  #   ls -la $out
  # '';
  buildPhase = ''
    patchelf \
      --set-rpath ${lib.makeLibraryPath [libfprint-tod]} \
      usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-goodix-53xc-$version.so
  '';

  installPhase = ''
    mkdir -p "$out/lib/libfprint-2/tod-1/"
    mkdir -p "$out/lib/udev/rules.d/"

    cp usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-goodix-53xc-$version.so "$out/lib/libfprint-2/tod-1/"
    cp lib/udev/rules.d/60-libfprint-2-tod1-goodix.rules "$out/lib/udev/rules.d/"
  '';

  passthru.driverPath = "/lib/libfprint-2/tod-1";
}
