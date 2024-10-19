{
  lib,
  stdenv,
  fetchFromGitHub,
  swiftPackages,
  # swiftpm2nix,
  # swift,
  # swiftpm,
}: let
  generated = swiftPackages.swiftpm2nix.helpers ./swift.nix;
in
  stdenv.mkDerivation rec {
    pname = "xcparse";
    version = "2.3.1";

    src = fetchFromGitHub {
      owner = "ChargePoint";
      repo = "xcparse";
      rev = version;
      hash = "sha256-4uOBqZ5R9UY5u8HJUAcxuX+o4AuM/wJRlrySYqfww64=";
    };

    nativeBuildInputs = [swiftPackages.swift swiftPackages.swiftpm];

    configurePhase = generated.configure;

    meta = {
      description = "Command line tool & Swift framework for parsing Xcode 11+ xcresult";
      homepage = "https://github.com/ChargePoint/xcparse";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [];
      mainProgram = "xcparse";
      platforms = lib.platforms.all;
    };
  }
