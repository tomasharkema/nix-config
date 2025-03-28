{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hidapi,
  catch2,
}:
stdenv.mkDerivation rec {
  pname = "ut61b";
  version = "unstable-2023-12-07";

  src = fetchFromGitHub {
    owner = "dariuskl";
    repo = "ut61b";
    rev = "c1f6935bc022fc0f0464ed9ea520d894b3e7b46f";
    hash = "sha256-qqD7PIK15ZKSGaZPf4oP+lGrFVJ4j7e8OuiotWYj2OQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    hidapi
    catch2
  ];

  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_CATCH2=${catch2}/lib/cmake/Catch2"
  ];

  meta = {
    description = "Simple monitoring utility for the UT61B multimeter";
    homepage = "https://github.com/dariuskl/ut61b";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "ut61b";
    platforms = lib.platforms.all;
  };
}
