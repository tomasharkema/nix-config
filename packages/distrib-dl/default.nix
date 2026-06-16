{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  makeWrapper,
  gnupg,
  wget,
  coreutils,
  python3,
}: let
  py = python3.withPackages (ps: with ps; [pylint]);
in
  stdenvNoCC.mkDerivation rec {
    pname = "distrib-dl";
    version = "2.0.16";

    src = fetchFromGitHub {
      owner = "nodiscc";
      repo = "distrib-dl";
      rev = version;
      sha256 = "sha256-W7l7MS/KWRNOcYVzhyV1gPTHyGqMNT0FYOqjfOcLIXs=";
    };

    nativeBuildInputs = [
      makeWrapper
      py
    ];

    buildInputs = [
      gnupg
      # wget2
      wget
      coreutils
    ];

    installPhase = ''
      runHook preInstall

      install -Dm 755 distrib-dl $out/bin/distrib-dl

      # patchShebangs $out/bin/distrib-dl

      # substituteInPlace $out/bin/distrib-dl \
      #   --replace-fail "--show-progress " ""

      # wrapProgram $out/bin/distrib-dl --set PATH ${
        lib.makeBinPath [gnupg wget coreutils]
      }

      runHook postInstall
    '';
  }
