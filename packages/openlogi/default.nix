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
  version = "0.6.16";
  __structuredAttrs = true;

  crateName = "openlogi-gui";

  src = fetchFromGitHub {
    owner = "AprilNEA";
    repo = "OpenLogi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lbV7F6LnaLvIS5IdGIcqrZTlCQ8WHtYJGmh6rZmFngs=";
  };

  cargoHash = "sha256-SoOWFEGXJO6n5HsUjP5hzCdQ+GZVSUU7czYsNuPBAIM=";

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
