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
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "noahbclarkson";
    repo = "rgitui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/yScN58WB+KWgx+Y2FyXq4Nha2xkukPjnvs9ojXsrdA=";
  };

  cargoHash = "sha256-mhGrKtMJ18rBba2u698fUvq5zNOrcklKuLu/OnO8QMw=";

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
