{
  lib,
  stdenv,
  fetchFromGitHub,
  elfutils,
  pkg-config,
  zstd,
  lzo,
  zlib,
  glibc,
  autoPatchelfHook,
  bzip2,
}: let
  isStatic = stdenv.hostPlatform.isStatic;
in
  stdenv.mkDerivation rec {
    pname = "makedumpfile";
    version = "1.7.8";

    src = fetchFromGitHub {
      owner = "makedumpfile";
      repo = "makedumpfile";
      rev = version;
      hash = "sha256-xUYIvNf7Td/PJreuadMTUwy0XaSQVes/9ltrJNiAwVw=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      pkg-config
    ];

    buildInputs = [
      elfutils
      zstd
      lzo
      zlib
      # glibc.static
      bzip2
    ];

    postInstall = ''
      mv $out/usr/sbin $out
      mv $out/usr/share $out
    '';

    makeFlags = [
      "USEZSTD=on"
      "USELZO=on"
      (lib.optionalString (!isStatic) "LINKTYPE=dynamic")
      "DESTDIR=${placeholder "out"}"
    ];

    meta = {
      description = "Make Linux crash dump small by filtering and compressing pages";
      homepage = "https://github.com/makedumpfile/makedumpfile";
      license = lib.licenses.gpl2Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "makedumpfile";
      platforms = lib.platforms.all;
    };
  }
