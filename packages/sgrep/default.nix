{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "sgrep";
  version = "unstable-2020-10-31";

  src = fetchFromGitHub {
    owner = "aca";
    repo = "sgrep";
    rev = "389d00cace669886ba883f50f7fd06702747031d";
    hash = "sha256-iq1rIIj1hw/G4OP9U16UZQtmJMso6CiDVKFIQbqlO+A=";
  };

  vendorHash = null;

  ldflags = ["-s" "-w"];

  meta = {
    description = "Simple grep. Extract url, ip address, email ... from stdin";
    homepage = "https://github.com/aca/sgrep";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "sgrep";
  };
}
