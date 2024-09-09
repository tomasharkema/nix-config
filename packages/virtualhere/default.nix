{
  lib,
  stdenv,
  fetchurl,
  libGL,
  makeWrapper,
  egl-wayland,
  libGLU,
  libglvnd,
}: let
  libpath = "$LD_LIBRARY_PATH:${
    lib.makeLibraryPath [libglvnd egl-wayland libGL libGLU]
  }";
in
  stdenv.mkDerivation rec {
    name = "virtualhere";
    version = "1.0.0";

    src =
      if stdenv.isx86_64
      then
        fetchurl {
          url = "https://www.virtualhere.com/sites/default/files/usbclient/vhuit64";
          hash = "sha256-kLZET/0xwgFYrSz8ReINXcFdE+lVYqszpiLOhZvSj+M=";
        }
      else
        fetchurl {
          url = "";
          hash = "";
        };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp $src $out/bin/vhuit64
      chmod +x $out/bin/vhuit64

      echo "${libpath}"

      wrapProgram $out/bin/vhuit64 --set LD_LIBRARY_PATH "${libpath}"

      runHook postInstall
    '';

    nativeBuildInputs = [makeWrapper];

    buildInputs = [
      libGL
      egl-wayland
    ];
  }
