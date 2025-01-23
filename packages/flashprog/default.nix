{
  lib,
  stdenv,
  fetchgit,
  cmake,
  ninja,
  libusb1,
  pciutils,
  pkg-config,
  libjaylink,
  libftdi1,
  libgpiod,
  dmidecode,
}:
stdenv.mkDerivation rec {
  pname = "flashprog";
  version = "1.3";

  src = fetchgit {
    url = "https://review.sourcearcade.org/flashprog.git";
    rev = "v${version}";
    hash = "sha256-S+UKDtpKYenwm+zR+Bg8HHxb2Jr7mFHAVCZdZTqCyRQ=";
  };

  nativeBuildInputs = [
    # cmake
    # ninja
    pkg-config
  ];
  makeFlags = ["PREFIX=$(out)"];

  buildInputs = [
    libusb1
    libjaylink
    libftdi1
    libgpiod
    dmidecode
    pciutils
  ];

  meta = {
    description = "";
    homepage = "https://review.sourcearcade.org/flashprog.git";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "flashprog";
    platforms = lib.platforms.all;
  };
}
