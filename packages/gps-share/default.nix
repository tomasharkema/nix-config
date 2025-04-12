{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:
rustPlatform.buildRustPackage rec {
  pname = "gps-share";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gps-share";
    rev = version;
    hash = "sha256-Rh7Pt9JN30TyuxwHOn8dwZrUfmkknUhOGonbhROpGxA=";
  };

  doCheck = false;

  cargoHash = "sha256-WhYHFaSZfnlEmlXFLj7BIt0agMFuz07LcAXJ9ZOOrvY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  meta = {
    description = "Utility to share your GPS device on local network";
    homepage = "https://github.com/zeenix/gps-share";
    changelog = "https://github.com/zeenix/gps-share/blob/${src.rev}/NEWS";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "gps-share";
  };
}
