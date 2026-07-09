{
  lib,
  python3Packages,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "shelly-cli";
  version = "0.1.12";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rvben";
    repo = "shelly-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H8sYjghsV3RMlT40oWXBpmDwm0GEuaTRRhQ9o4DlIf0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-L1lwygQ7XbsNPmqyyHofnr1wU5MQC2XHYGipexhA0QU=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  pythonImportsCheck = [
    "shelly_cli"
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "CLI for managing and controlling Shelly devices";
    homepage = "https://github.com/rvben/shelly-cli";
    changelog = "https://github.com/rvben/shelly-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "shelly-cli";
  };
})
