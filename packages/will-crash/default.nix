{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  openjdk,
  pkg-config,
  ruby_3_1,
  cmake,
  buildPackages,
}: let
  r = ruby_3_1.withPackages (ps: with ps; [pg ps.pkg-config ruby-graphviz]);
in
  stdenv.mkDerivation rec {
    pname = "will-crash";
    version = "0.13.5";

    src = fetchFromGitHub {
      owner = "abrt";
      repo = "will-crash";
      rev = "v${version}";
      hash = "sha256-8szrbUpotGik+NyN3pKhs1vP+swmEJifCffKjzlLtGA=";
    };

    enableParallelBuilding = true;
    depsBuildBuild = [pkg-config r buildPackages.stdenv.cc];
    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      cmake
      r
      openjdk
    ];

    buildInputs = [
      r
      openjdk
    ];

    preBuild = ''
      export NUMBER_OF_PROCESSORS=$NIX_BUILD_CORES
      export NIX_CFLAGS_COMPILE="$(pkg-config --cflags ruby) $NIX_CFLAGS_COMPILE"
    '';

    # mesonFlags = ["--verbose"];

    # prePatch = ''
    #   mv meson.build-nojava meson.build
    # '';

    preConfigure = ''
      echo "PKG_CONFIG_PATH $PKG_CONFIG_PATH"
    '';

    meta = with lib; {
      description = "Set of crashing executables written in various languages";
      homepage = "https://github.com/abrt/will-crash";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [];
      mainProgram = "will-crash";
      platforms = platforms.all;
    };
  }
