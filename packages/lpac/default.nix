{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
}:
stdenv.mkDerivation rec {
  pname = "lpac";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "estkme-group";
    repo = "lpac";
    rev = "v${version}";
    hash = "sha256-3ShK07+kEs50dwmolWRn9SKXRkMfMvRx0uX5tvWlKgc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    curl
  ];

  meta = with lib; {
    description = "C-based eUICC LPA";
    homepage = "https://github.com/estkme-group/lpac";
    # license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "lpac";
    platforms = platforms.all;
  };
}
