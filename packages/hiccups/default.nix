{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hiccups";
  version = "1.0.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "rigtorp";
    repo = "hiccups";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uEweU67gyBOk7Cq+8DJTyPi6SGPoxlaJv3xWNuPRLoQ=";
  };

  nativeBuildInputs = [
    cmake
  ];
  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];
  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Measures the system induced jitter (\"hiccups\") a CPU bound thread experiences";
    homepage = "https://github.com/rigtorp/hiccups";
    changelog = "https://github.com/rigtorp/hiccups/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "hiccups";
    platforms = lib.platforms.all;
  };
})
