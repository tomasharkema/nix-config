{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  binutils,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "unifly";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "hyperb1iss";
    repo = "unifly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u+nERyym51tPD13QGNO0XeqPse+qydWT9wudpwfJuso=";
  };

  cargoHash = "sha256-71kQ6Rv79ehW2h4cmD0L3DGOC3sfv4Qw1KK0KNN/c/g=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    binutils
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
