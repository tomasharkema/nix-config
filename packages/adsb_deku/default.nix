{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "adsb-deku";
  version = "2024.09.02";

  src = fetchFromGitHub {
    owner = "rsadsb";
    repo = "adsb_deku";
    rev = "v${version}";
    hash = "sha256-+WUG/CQ/j3muYow2FMFNUgWWhOCPZc0k+okoF1p1L5Y=";
  };

  cargoHash = "sha256-wLx800lGWuDHep0O9Ds3N3ml4TRDNbEoJeodjXdyUHo=";

  meta = {
    description = "Rust ADS-B decoder + tui radar application";
    homepage = "https://github.com/rsadsb/adsb_deku";
    changelog = "https://github.com/rsadsb/adsb_deku/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "adsb-deku";
  };
}
