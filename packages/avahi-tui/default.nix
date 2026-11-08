{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avahi-tui";
  version = "0.3.13";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "abbyssoul";
    repo = "avahi-tui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2vFWcBiMcQQPmQ+zCVSOrKSXvOU3YgzObyg08/JU+Gs=";
  };

  cargoHash = "sha256-H8NvJSaVMd01czHhH6Kz6K2q8fSiFyULjUv1nBpaZSQ=";

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
