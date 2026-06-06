{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  freetype,
  libgit2,
  libxkbcommon,
  openssl,
  vulkan-loader,
  zlib,
  stdenv,
  wayland,
  libxcb,
}:
# xorg.libX11
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgitui";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "noahbclarkson";
    repo = "rgitui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dIa2cR2wOdbobZIkrY0qoDIiormbTg0Xge/KDnXe9VQ=";
  };

  cargoHash = "sha256-JIaSjbYef147hVRckeOEywIw+ln9A+d+o++5b2FUaXQ=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      fontconfig
      freetype
      libgit2
      libxkbcommon
      openssl
      vulkan-loader
      zlib
    ]
    ++ lib.optionals stdenv.isLinux [
      wayland
      libxcb
    ];

  meta = {
    description = "A GPU-accelerated desktop Git client built in Rust with GPUI";
    homepage = "https://github.com/noahbclarkson/rgitui";
    changelog = "https://github.com/noahbclarkson/rgitui/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "rgitui";
  };
})
