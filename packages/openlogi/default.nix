{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  freetype,
  libxkbcommon,
  vulkan-loader,
  stdenv,
  wayland,
  xorg,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "open-logi";
  version = "0.6.14";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AprilNEA";
    repo = "OpenLogi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/OSE1xC8fGX2ajwAvAQAJx4assXlRCpufJ4qK7Gd06Y=";
  };

  cargoHash = "sha256-Y60MbpWfOpXgrvOhvJUsJpp1UH0oF6XVTUSD4LAgu8A=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      fontconfig
      freetype
      libxkbcommon
      vulkan-loader
    ]
    ++ lib.optionals stdenv.isLinux [
      wayland
      xorg.libX11
      xorg.libxcb
    ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A native, local-first alternative to Logitech Options+, written in Rust 🦀 — remap buttons, DPI, and SmartShift over HID++. No account, no telemetry";
    homepage = "https://github.com/AprilNEA/OpenLogi";
    changelog = "https://github.com/AprilNEA/OpenLogi/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [];
    mainProgram = "open-logi";
  };
})
