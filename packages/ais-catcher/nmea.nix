{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  clang,
  libgcc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nmea2000";
  version = "0-unstable-2025-12-28";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jvde-github";
    repo = "NMEA2000";
    rev = "6d23fae3e6f197eeae913f401109ad5258a6844b";
    hash = "sha256-zBuu91TnGh7NwotJQbcQgUCrC0zrMudE/SCxIAYH5Xw=";
  };

  nativeBuildInputs = [
    cmake
    clang
    libgcc
  ];

  buildInputs = [
    libgcc
  ];

  cmakeFlags = ["-DCMAKE_POLICY_VERSION_MINIMUM=3.5"];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "NMEA2000 library for Arduino";
    homepage = " ";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "nmea2000";
    platforms = lib.platforms.all;
  };
})
