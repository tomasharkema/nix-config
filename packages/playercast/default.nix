# playercast
{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  libcec,
  ffmpeg,
}:
buildNpmPackage rec {
  pname = "playercast";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Rafostar";
    repo = "playercast";
    rev = "v${version}";
    hash = "sha256-sx67rA2jwAsWbmT6fnV5mM5H4lmb/z1D/5hig1Rw7TU=";
  };
  npmDepsHash = "sha256-pkafG5z4IHL0rcojNvKocWZR526Sv3LDjKsPvV5YPD4=";
  dontNpmBuild = true;

  buildInputs = [libcec ffmpeg];

  propagatedBuildInputs = [libcec ffmpeg];

  meta = {
    description = "playercast";
    # license = licenses.lgpl21;
    # homepage = "https://github.com/cockpit-project/cockpit-machines";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [];
  };
}
