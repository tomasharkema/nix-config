{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libgphoto2,
  ffmpeg,
  kmod,
}:
stdenv.mkDerivation rec {
  pname = "webcamize";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "cowtoolz";
    repo = "webcamize";
    rev = "v${version}";
    hash = "sha256-rmATEcAcngCHidMFXNocrhP06LKNLEb+9jfFMGL4AKU=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  nativeBuildInputs = [pkg-config];
  buildInputs = [
    libgphoto2
    ffmpeg
    kmod
  ];

  meta = {
    description = "Use (almost) any camera as a webcam";
    homepage = "https://github.com/cowtoolz/webcamize";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [];
    mainProgram = "webcamize";
    platforms = lib.platforms.all;
  };
}
