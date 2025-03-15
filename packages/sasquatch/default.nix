{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "sasquatch";
  version = "unstable-2021-03-25";

  src = fetchFromGitHub {
    owner = "devttys0";
    repo = "sasquatch";
    rev = "bd864a1b037bf57ca7d64a292a60ba0d6459611f";
    hash = "sha256-2FkJQGUm6Pge/bdx/cxf6Js/ZUUW3FNE/D95IOYu0NY=";
  };

  meta = {
    description = "";
    homepage = "https://github.com/devttys0/sasquatch";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "sasquatch";
    platforms = lib.platforms.all;
  };
}
