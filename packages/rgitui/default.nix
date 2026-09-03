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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rgitui";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "noahbclarkson";
    repo = "rgitui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h2ZlFi7PEKX2FfPuNpsROGOpMNpaV2kd30w1m6oyU0k=";
  };

  cargoHash = "sha256-BWnxkrIT6YSiGeA7YnYgbt+IVw9/ym8FAav5EzmqUGI=";

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
