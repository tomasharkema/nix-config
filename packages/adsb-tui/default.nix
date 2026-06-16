{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adsb-tui";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "j4v3l";
    repo = "ADS-B_TUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o/eZ2qD367RWKk9q8temiP/w1lP5gEX9Hum9TrFdXpI=";
  };

  cargoHash = "sha256-z/3CVWJFE7TIrTJfGwCmImwxR06Splrg2DRGcPGxGRM=";

  meta = {
    description = "A modern, fast, and user-friendly terminal interface for tracking aircraft using ADS-B data. Display real-time flight information in a beautiful table format with country flags, routes, and more";
    homepage = "https://github.com/j4v3l/ADS-B_TUI";
    changelog = "https://github.com/j4v3l/ADS-B_TUI/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    # mainProgram = "ads-b-tui";
  };
})
