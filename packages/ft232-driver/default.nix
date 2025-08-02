{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "ft2232-mpsse-i2c-spi-kern-drivers";
  version = "unstable-2024-03-01";

  src = fetchFromGitHub {
    owner = "bm16ton";
    repo = "ft2232-mpsse-i2c-spi-kern-drivers";
    rev = "9bfd9a2993645550a22e2b6e9de42a3a43ae3c07";
    hash = "sha256-ElZI+GiKU9VPffbfJN9lCm/j2xB38s1V/QN+bg9SRDc=";
    fetchSubmodules = true;
  };

  meta = {
    description = "Linux kernel drivers for ft2232 spi and i2c";
    homepage = "https://github.com/bm16ton/ft2232-mpsse-i2c-spi-kern-drivers";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "ft2232-mpsse-i2c-spi-kern-drivers";
    platforms = lib.platforms.all;
  };
}
