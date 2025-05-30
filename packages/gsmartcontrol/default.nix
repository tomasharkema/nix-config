{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtkmm3,
}:
stdenv.mkDerivation rec {
  pname = "gsmartcontrol";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "ashaduri";
    repo = "gsmartcontrol";
    rev = "v${version}";
    hash = "sha256-eLzwFZ1PYqijFTxos9Osf7A2v4C8toM+TGV4/bU82NE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [gtkmm3];
  meta = {
    description = "GSmartControl - Hard disk drive and SSD health inspection tool";
    homepage = "https://github.com/ashaduri/gsmartcontrol";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "gsmartcontrol";
    platforms = lib.platforms.all;
  };
}
