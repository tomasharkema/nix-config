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
  aws-lc,
  oniguruma,
  sqlite,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgitui";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "noahbclarkson";
    repo = "rgitui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QjoCFqe4mMgKd6BOnc4EA60VtbQZUvk9J4dMzc7rTO4=";
  };

  cargoHash = "sha256-DZsqupOyK8W5uyvDvsvh+a9RWVd7OoYyGSkMtdA1nEY=";

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
      aws-lc
      oniguruma
      sqlite
      #zpkgs.std
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
