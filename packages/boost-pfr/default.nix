{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "pfr";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "boostorg";
    repo = "pfr";
    rev = version;
    hash = "sha256-YpKObkuJMjTQEUPIerRvVfdPxy6fl9Om33hpROm1rjw=";
  };

  cmakeFlags = ["-DBOOST_USE_MODULES=1"];
  doCheck = false;
  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildPhase = ''ninja'';
  # installPhase = ''
  # ls -la
  # cat build.ninja
  # sleep 1000
  # '';

  meta = {
    description = "Std::tuple like methods for user defined types without any macro or boilerplate code";
    homepage = "https://github.com/boostorg/pfr";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [];
    mainProgram = "pfr";
    platforms = lib.platforms.all;
  };
}
