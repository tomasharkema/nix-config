# https://github.com/SourceArcade/flashprog.git
{
  fetchFromGitHub,
  stdenv,
  pkg-config,
  libusb,
  libftdi1,
  libjaylink,
  libgpiod,
  pciutils,
}:
stdenv.mkDerivation rec {
  pname = "flashprog";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "SourceArcade";
    repo = "flashprog";
    rev = "v${version}";
    hash = "sha256-IP/i1JsQ/HTRn4N2jOVWIjzazPbFkhhXSxL45uZhcOg=";
  };
  installFlags = ["DESTDIR=$(out)"];
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    libusb
    libftdi1
    libjaylink
    libgpiod
    pciutils
  ];
}
