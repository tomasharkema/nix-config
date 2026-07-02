{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "radar";
  # version = "2025.05.03";
  version = "unstable-e2bdf1";

  src = fetchFromGitHub {
    owner = "rsadsb";
    repo = "adsb_deku";
    # rev = "v${version}";
    rev = "e2bdf1e08d1ef1a8dbdea25f415cbd50170de60e";
    # hash = "sha256-MmCaH9SNxuDLOJGd/lc68fYnZyg01S7m9u9cVQxmBTw=";
    hash = "sha256-WhULcgw9hDanOeIc4VitLth0P6pvSh49S18R1tWz3R0=";
  };

  cargoHash = "sha256-TuMf8oaKaSeGPXHxn8LB9skTKvdIIEpGgnI5BVZxkLQ=";

  meta = {
    description = "Rust ADS-B decoder + tui radar application";
    homepage = "https://github.com/rsadsb/adsb_deku";
    changelog = "https://github.com/rsadsb/adsb_deku/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "radar";
  };
}
