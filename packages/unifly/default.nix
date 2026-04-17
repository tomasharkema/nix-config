{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "unifly";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "hyperb1iss";
    repo = "unifly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZFVqEA/Ft+vYtNvvbR0MPdVVNM/W88169zU5CqZcBXY=";
  };

  cargoHash = "sha256-j/poN2AdCeSNymYUAWxpy0MMqF5ZF5LTKrP1016oc94=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = {
    description = "Elegant UniFi network management CLI & TUI - for humans and agents";
    homepage = "https://github.com/hyperb1iss/unifly";
    changelog = "https://github.com/hyperb1iss/unifly/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [];
    mainProgram = "unifly";
  };
})
