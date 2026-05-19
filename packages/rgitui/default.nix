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
  xorg,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgitui";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "noahbclarkson";
    repo = "rgitui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D/wCu60CdRge+rKPHloS2OXvBlMofK7UGx4O4x/GMy0=";
  };

  cargoHash = "sha256-Ife/HTnZrmdsD08X1b9A43tWsw625jYMZkFdAKAMWm8=";

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
      xorg.libX11
      xorg.libxcb
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
