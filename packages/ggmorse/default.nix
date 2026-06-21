{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  SDL2,
  pkg-config,
  libGLX,
  libx11,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ggmorse";
  version = "0-unstable-2024-05-31";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wave-owl";
    repo = "ggmorse";
    rev = "8fb433d6cd6a71940f51b5724663ec0c75bf0b62";
    hash = "sha256-K0OpKhxwcPENAmNGV6zP63EJZoh9C20xS0fyT58ciHo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    SDL2
    libGLX
    libx11
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Mirror of https://github.com/ggerganov/ggmorse — maintained for Wave Owl build stability";
    homepage = "https://github.com/wave-owl/ggmorse";
    changelog = "https://github.com/wave-owl/ggmorse/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "ggmorse";
    platforms = lib.platforms.all;
  };
})
