{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "partclone-nbd";
  version = "unstable-2021-02-06";

  src = fetchFromGitHub {
    owner = "allvpv";
    repo = "partclone-nbd";
    rev = "7bb76d5892ec69654822a04718a91f9378b02589";
    hash = "sha256-jisOwl3y4eiyc8fsdNtufVO2fRjGBTee1dYLYjuYGis=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Partclone-nbd - export partclone/clonezilla images as block devices without restoring them";
    homepage = "https://github.com/allvpv/partclone-nbd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "partclone-nbd";
    platforms = lib.platforms.all;
  };
}
