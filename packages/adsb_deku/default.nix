{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "adsb-deku";
  version = "2025.05.03";

  src = fetchFromGitHub {
    owner = "rsadsb";
    repo = "adsb_deku";
    rev = "v${version}";
    hash = "sha256-MmCaH9SNxuDLOJGd/lc68fYnZyg01S7m9u9cVQxmBTw=";
  };

  cargoHash = "sha256-w5/nDcrWG6v3iIvXvEKc1O0F9WBx+5oFnGLqK39u5mQ=";

  meta = {
    description = "Rust ADS-B decoder + tui radar application";
    homepage = "https://github.com/rsadsb/adsb_deku";
    changelog = "https://github.com/rsadsb/adsb_deku/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "radar";
  };
}
