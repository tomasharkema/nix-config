{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  vulkan-loader,
  stdenv,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dev-toolbox";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "avomar";
    repo = "dev-toolbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W4neeyPSrW45TneAwJnILKEJa1yar9vUEDUbdXvGHqM=";
  };

  cargoHash = "sha256-Tf2b4zmVr0ARwuBs2KgN5G20FYSHmUbHWbQNuCdkETg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libxkbcommon
      vulkan-loader
    ]
    ++ lib.optionals stdenv.isLinux [
      wayland
    ];

  meta = {
    description = "Everyday utilities for developers";
    homepage = "https://github.com/avomar/dev-toolbox";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "dev-toolbox";
  };
})
