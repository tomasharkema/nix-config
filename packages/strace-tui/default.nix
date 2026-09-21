{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "strace-tui";
  version = "1.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Rodrigodd";
    repo = "strace-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VHBXZ1b5emqroFI5OswxXXq1BFNbm6iJlAAso93+Nr4=";
  };

  cargoHash = "sha256-8911bjw1v4pq/84L+B+x+WnKxGbTi5Og1xOxcwn9vHI=";

  doCheck = false;

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A terminal user interface (TUI) for visualizing and exploring strace output";
    homepage = "https://github.com/Rodrigodd/strace-tui";
    changelog = "https://github.com/Rodrigodd/strace-tui/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [];
    mainProgram = "strace-tui";
  };
})
