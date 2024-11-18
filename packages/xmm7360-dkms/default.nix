{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "xmm7360-dkms";
  version = "unstable-2021-09-24";

  src = fetchFromGitHub {
    owner = "isabella232";
    repo = "xmm7360-dkms";
    rev = "e5f3121eaa4fcee1d4bb2ef8fb845370f1c603e1";
    hash = "sha256-bWf2C79tOEJFT9pbVNrBBSQDsgOsOTRiB3EcROxU8Dc=";
  };

  meta = with lib; {
    description = "Pop!_OS fork of https://github.com/xmm7360/xmm7360-pci";
    homepage = "https://github.com/isabella232/xmm7360-dkms";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "xmm7360-dkms";
    platforms = platforms.all;
  };
}
