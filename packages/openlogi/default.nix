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
  nix-update-script,
  libx11,
  libxcb,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openlogi";
  version = "0.8.11";
  __structuredAttrs = true;

  crateName = "openlogi-gui";

  src = fetchFromGitHub {
    owner = "AprilNEA";
    repo = "OpenLogi";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-zoG0a28Z+bxAipK/auAEmGWje8Zwbryyy3lSj6agNiQ=";
  };

  cargoHash = "sha256-AsT6t1FuwdkBC/CIXkXrZnwbZuXp7RjUXI9XpeT2YPE=";

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
      libx11
      libxcb
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
