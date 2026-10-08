{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  custom,
  fetchzip,
  dpkg,
  autoPatchelfHook,
}: let
  version = "2024.12.1-0";
  debian = fetchzip {
    url = "https://github.com/SiliconLabs/simplicity_sdk/releases/download/v${version}/debian-bookworm.zip";
    hash = "sha256-8QCZ1nHcxYHoFl5zQ6X2yo/X96u5wK5N0FlyfDRXTaI=";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "zigbeed";
    inherit version;
    __structuredAttrs = true;
    strictDeps = true;

    src = "${debian}/deb/zigbeed_8.1.1_amd64.deb";

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
    ];

    buildInputs = [custom.cpc-daemon];

    postInstall = ''
      mkdir -p $out/bin
      cp -rv ./usr/local/* $out
    '';

    meta = {
      description = "The Simplicity Software Development Kit (SDK) is an embedded software development platform for building IoT products based on our Series 2 and upcoming Series 3 wireless and MCU devices";
      homepage = "https://github.com/SiliconLabs/simplicity_sdk";
      changelog = "https://github.com/SiliconLabs/simplicity_sdk/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.unfree; # FIXME: nix-init did not find a license
      maintainers = with lib.maintainers; [];
      mainProgram = "simplicity-sdk";
      platforms = lib.platforms.all;
    };
  })
