{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "macos-btrfs";
  version = "unstable-2024-10-07";

  src = fetchFromGitHub {
    owner = "relalis";
    repo = "macos-btrfs";
    rev = "c5352ffd3429583a31ea6dc1a9fb4a4b1351aa01";
    hash = "sha256-s5AwUh0QYOxmhFEOJp+xh+HdWSeVBEfIXt1JIyJs+xc=";
  };

  meta = {
    description = "BTRFS filesystem plugin for macOS";
    homepage = "https://github.com/relalis/macos-btrfs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [];
    mainProgram = "macos-btrfs";
    platforms = lib.platforms.all;
  };
}
