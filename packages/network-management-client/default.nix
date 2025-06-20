{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  nodePackages,
}:
stdenv.mkDerivation rec {
  pname = "network-management-client";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "meshtastic";
    repo = "network-management-client";
    rev = "v${version}";
    hash = "sha256-XBr6lrmvTi2jP3/dcnV5/S74Tkt8UxI8GTeuWLfGGBc=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    nodejs
    nodePackages.pnpm
  ];
  meta = {
    description = "A Meshtastic desktop client, allowing simple, offline deployment and administration of an ad-hoc mesh communication network. Built in Rust and TypeScript";
    homepage = "https://github.com/meshtastic/network-management-client";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "network-management-client";
    platforms = lib.platforms.all;
  };
}
