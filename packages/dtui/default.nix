{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "dtui";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Troels51";
    repo = "dtui";
    rev = "v${version}";
    hash = "sha256-QHMkOlymLi57MLS5J/8vLJwMcyxDVLKfJC4s0RZ60nU=";
  };

  cargoHash = "sha256-rI4twKo2YdIiWCNXPhEe/rexxtpeM4CS1aDo4zpLHdg=";

  meta = with lib; {
    description = "Small TUI for introspecting the state of the system/session dbus";
    homepage = "https://github.com/Troels51/dtui";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "dtui";
  };
}
