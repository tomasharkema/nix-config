{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  autoPatchelfHook,
}: let
  arch = "x86_64";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "swiftly";
    version = "1.1.1";

    src = fetchzip {
      url = "https://download.swift.org/swiftly/linux/swiftly-${arch}.tar.gz";
      hash = "sha256-FAZ3nnZGzCaBDlRCc6w7u9lHwyRgsSWT/1Zbd1iUaOQ=";
      stripRoot = false;
    };

    postInstall = ''
      install -D ./swiftly $out/bin/swiftly
    '';

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    meta = {
      description = "A Swift toolchain installer and manager, written in Swift";
      homepage = "https://github.com/swiftlang/swiftly";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [];
      mainProgram = "swiftly";
      platforms = lib.platforms.all;
    };
  })
