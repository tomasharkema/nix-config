{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "recalendar";
  version = "unstable-2024-12-03";

  src = fetchFromGitHub {
    owner = "klimeryk";
    repo = "recalendar.js";
    rev = "e2c5714f529bc79b922e55d8968ee90fa76b7aaa";
    hash = "sha256-dKl9qF0GSkcNuzvMTAewRAbiYtxz7yuVsdt4dFjrLCQ=";
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
