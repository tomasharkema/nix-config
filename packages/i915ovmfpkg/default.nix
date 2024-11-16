{
  lib,
  stdenv,
  fetchFromGitHub,
}: let
  edk = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2";
    rev = "13fad60156f18cf0d2043fb7f05c1dc5e3d91fb7";
    hash = "sha256-jYvZ2Yv43ur4kqHLQuLqJ6gSHl0BDP3Vk9NL0lJ8aAE=";
  };
  edk-platforms = fetchFromGitHub {
    owner = "tianocore";
    repo = "edk2-platforms";
    rev = "9ddb3fb98d325e075aa6d748953f2b9d742a5a78";
    hash = "sha256-mw8gcKrJZnt2g8/aDMw0d0g2tXqZAk3p3vuAVmkedJg=";
  };
in
  stdenv.mkDerivation rec {
    pname = "i915ovmf-pkg";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "x78x79x82x79";
      repo = "i915ovmfPkg";
      rev = "v${version}";
      hash = "sha256-uTCyidJspWw/YopowIkLFmLTmP66FfV9zjaVPm1MNCQ=";
    };

    buildPhase = ''
      temp=$(mktemp -d)

      set -x

      export REPO_DIR=$temp

      cp -r ${edk}/. $temp/edk2
      cp -r ${edk-platforms}/. $temp/edk2-platforms

      export EDK2_PATH=$temp/edk2
      export EDK2_PLATFORMS_PATH=$temp/edk2-platforms

      echo "temp $temp"

      ls -la $temp

      sh build.sh
    '';

    meta = with lib; {
      description = "VBIOS for Intel GPU Passthrough";
      homepage = "https://github.com/x78x79x82x79/i915ovmfPkg";
      license = licenses.unfree; # FIXME: nix-init did not found a license
      maintainers = with maintainers; [];
      mainProgram = "i915ovmf-pkg";
      platforms = platforms.all;
    };
  }
