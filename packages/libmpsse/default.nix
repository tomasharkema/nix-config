{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
  autoreconfHook,
  pkg-config,
  libftdi,
  which,
  gettext,
  swig,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "libmpsse";
  version = "1.3";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libmpsse/libmpsse-${version}.tar.gz";
    sha256 = "sha256-CPKgAlB0cg1A4pQwCJsat412R1bMXSvLMUjZgTG0B0s=";
  };

  sourceRoot = "./libmpsse-1.3/src";

  prePatch = ''ls -la'';

  nativeBuildInputs = [
    autoPatchelfHook
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libftdi
    which
    gettext
    python3
    swig
  ];
}
