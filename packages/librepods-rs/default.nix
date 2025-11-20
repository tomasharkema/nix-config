{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  openssl,
  pulseaudioFull,
}:
rustPlatform.buildRustPackage rec {
  pname = "librepods-rs";
  version = "0.1.0-rc.4";

  src = fetchFromGitHub {
    owner = "kavishdevar";
    repo = "librepods";
    rev = "linux/rust";
    hash = "sha256-ZvHbSSW0rfcsNUORZURe0oBHQbnqmS5XT9ffVMwjIMU=";
  };

  sourceRoot = "${src.name}/linux-rust";

  cargoHash = "sha256-Ebqx+UU2tdygvqvDGjBSxbkmPnkR47/yL3sCVWo54CU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
    pulseaudioFull
  ];

  meta = {
    # description = "Rust ADS-B decoder + tui radar application";
    # homepage = "https://github.com/rsadsb/adsb_deku";
    # changelog = "https://github.com/rsadsb/adsb_deku/blob/${src.rev}/CHANGELOG.md";
    # license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [];
    # mainProgram = "radar";
  };
}
