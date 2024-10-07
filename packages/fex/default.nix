{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  clang,
}:
stdenv.mkDerivation rec {
  pname = "fex";
  version = "2409";

  src = fetchFromGitHub {
    owner = "FEX-Emu";
    repo = "FEX";
    rev = "FEX-${version}";
    hash = "sha256-1yMoQIoX+drIaeAVDP5Me40VOU+mYrU0cIqx0AV52SY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    clang
  ];

  meta = with lib; {
    description = "A fast usermode x86 and x86-64 emulator for Arm64 Linux";
    homepage = "https://github.com/FEX-Emu/FEX";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "fex";
    platforms = platforms.all;
  };
}
