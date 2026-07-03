{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avahi-tui";
  version = "0-unstable-2026-07-03";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "abbyssoul";
    repo = "avahi-tui";
    rev = "eced882c2937f7eddf9b9f1649cf1889b5e25e3a";
    hash = "sha256-4V5DD6KVkLwQWw3rd7dNBxrdZJNZtP7VYASeK2Z0WHk=";
  };

  cargoHash = "sha256-ove3lXsh+PQW5UcGqGqs93jt4Xw8Zfyr40k5uexRtEs=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "TUI browser and command launcher for local services";
    homepage = "https://github.com/abbyssoul/avahi-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "avahi-tui";
  };
})
