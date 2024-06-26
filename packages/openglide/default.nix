{
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libGL,
  libGLU,
  SDL,
  xorg,
}:
stdenv.mkDerivation {
  pname = "openglide";
  version = "0.0.1";

  # https://github.com/voyageur/openglide
  src = fetchFromGitHub {
    owner = "voyageur";
    repo = "openglide";
    rev = "ad9a3ddbf17b42e73fa7fbae09bceef1ebddcd92";
    sha256 = "sha256-wiwylW3Ab5CoMbCzIf9UpTe7cn271c2V5nvBKE6W/t0=";
  };

  nativeBuildInputs = [autoreconfHook];
  buildInputs = [libGL SDL xorg.libX11 libGLU];
}
