{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "i-fr";
  version = "unstable-2024-07-10";

  src = fetchFromGitHub {
    owner = "Jazzzny";
    repo = "iFR";
    rev = "8ac9a394fe023642f4c7145cf029470f3f04ade9";
    hash = "sha256-G8ouutDo4W46DwLnUVdlrvCDE5HYTRRcBrgDjkv/L9g=";
  };

  meta = {
    description = "A simple yet powerful GUI for Flashrom";
    homepage = "https://github.com/Jazzzny/iFR";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "i-fr";
    platforms = lib.platforms.all;
  };
}
