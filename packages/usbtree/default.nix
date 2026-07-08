{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usbtree";
  version = "0.0.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gnomeria";
    repo = "usbtree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N4rPS6Oq6tZ5YWuXjXIv5xRc7Y495+vkWzg6DmEbdFo=";
  };

  cargoHash = "sha256-0C4A6OSP7VJs8rY6rm92QmNEQ2eeNTAZDZ5GWEeQ1Fo=";

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Live USB device tree in your terminal. Rust TUI, no root, no libusb. Full activity metrics on Linux; device tree on macOS/Windows";
    homepage = "https://github.com/gnomeria/usbtree";
    changelog = "https://github.com/gnomeria/usbtree/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "usbtree";
  };
})
