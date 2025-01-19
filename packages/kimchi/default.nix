{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoconf,
  automake,
  autoreconfHook,
  autoPatchelfHook,
  gettext,
}:
stdenv.mkDerivation rec {
  pname = "kimchi";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "kimchi-project";
    repo = "kimchi";
    rev = version;
    hash = "sha256-tm0QtqebJjSAFLPj5d7MPQYKGbQlaw7spx6IOk0BOnw=";
  };

  nativeBuildInputs = [
    pkg-config
    # autoconf
    # automake
    autoreconfHook
    autoPatchelfHook
  ];
  buildInputs = [];
  meta = {
    description = "An HTML5 management interface for KVM guests";
    homepage = "https://github.com/kimchi-project/kimchi";
    changelog = "https://github.com/kimchi-project/kimchi/blob/${src.rev}/ChangeLog";
    license = with lib.licenses; [lgpl21Only asl20];
    maintainers = with lib.maintainers; [];
    mainProgram = "kimchi";
    platforms = lib.platforms.all;
  };
}
