{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:
stdenv.mkDerivation rec {
  pname = "spi-tools";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "cpb-";
    repo = "spi-tools";
    rev = version;
    hash = "sha256-lrdoO4ZsZCf0pt1SSL5w4rXVuYzlkJZQpditYt61nUw=";
  };

  nativeBuildInputs = [autoreconfHook];

  meta = {
    description = "Simple command line tools to help using Linux spidev devices";
    homepage = "https://github.com/cpb-/spi-tools";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "spi-tools";
    platforms = lib.platforms.all;
  };
}
