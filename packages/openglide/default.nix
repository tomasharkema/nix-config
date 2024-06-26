{
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libGL,
  libGLU,
  SDL2,
  SDL2_net,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "openglide";
  version = "0.0.1";

  # https://github.com/voyageur/openglide
  # https://github.com/kjliew/qemu-xtra/tree/master/openglide
  src = fetchFromGitHub {
    owner = "kjliew";
    repo = "qemu-xtra";
    rev = "23bb5bed959320417e12c5a4c1610f9d84fcd3f5";
    sha256 = "sha256-sJzvYNgomGzXrZH/9dmDgpbueYelLf2LJ/DQHut0Bz0=";
  };

  sourceRoot = "${src.name}/openglide";

  nativeBuildInputs = [autoreconfHook];
  buildInputs = [libGL SDL2 SDL2_net xorg.libX11 libGLU];
}
