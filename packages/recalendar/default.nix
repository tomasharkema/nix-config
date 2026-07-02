{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "recalendar";
  version = "unstable-2026-12-03";

  src = fetchFromGitHub {
    owner = "klimeryk";
    repo = "recalendar.js";
    rev = "6975bd14925bd5356af1cf3703176b321793f039";
    hash = "sha256-/0h3iArOjkElWSkwN2X63yae3ojId41HLG3w3829o1E=";
  };

  npmDepsHash = "sha256-0l2YPiA79xj2xmB8OwqLUkxYWeC2edirOVfIuPmIyV0=";

  meta = {
    description = "ReCalendar - create your personalized calendar PDF for ReMarkable tablets";
    homepage = "https://github.com/klimeryk/recalendar.js/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "recalendar-js";
    platforms = lib.platforms.all;
  };
}
