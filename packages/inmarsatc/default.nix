{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "inmarsatc";
  version = "0-unstable-2023-07-10";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "cropinghigh";
    repo = "inmarsatc";
    rev = "cda1242e79981d71cd8608e971c8dbc691942b10";
    hash = "sha256-UCmdHR9bSr1x4G0OP7n+o6pdS1thTl9hzH7YMykSiGw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Inmarsat-C open-source C++ decoder lib based on Scytale-C";
    homepage = "https://github.com/cropinghigh/inmarsatc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "inmarsatc";
    platforms = lib.platforms.all;
  };
})
