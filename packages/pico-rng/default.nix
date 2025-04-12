{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkgs,
  kernel ? pkgs.linuxPackages_latest.kernel,
}: let
  kernelBuild = "${kernel.dev}/lib/modules/${kernel.modDirVersion}";
  kernelSource = "${kernelBuild}/source";
in
  stdenv.mkDerivation rec {
    pname = "pico-rng";
    version = "1.0";

    src = fetchFromGitHub {
      owner = "polhenarejos";
      repo = "pico-rng";
      rev = "v${version}";
      hash = "sha256-BxA0zXXjQmYPSIA6XsVt8nNJT0sXPCL1Fys6V9aSGWY=";
    };

    sourceRoot = "${src.name}/driver";

    nativeBuildInputs =
      [
        cmake
      ]
      ++ kernel.moduleBuildDependencies;

    cmakeFlags = [
      "-DKERNEL_RELEASE=${kernel.modDirVersion}"
      "-DKERNELHEADERS_DIR=${kernelBuild}/build"
      # "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
      # "--debug-output"
    ];

    makeFlags = [
      # "-d"
      # "KERNELRELEASE=${kernel.modDirVersion}"
      # "KERNEL_DIR=${kernelBuild}/build"
      # "INSTALL_MOD_PATH=${placeholder "out"}"
      # "CMAKE_INSTALL_PREFIX=${placeholder "out"}"
      # "KERNELHEADERS_DIR=${kernelSource}/include"
    ];

    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail '/usr/src/linux-headers-''${KERNEL_RELEASE}' "${kernelBuild}/build" \
        --replace-fail "COMMAND uname -r" "COMMAND echo ${kernel.modDirVersion}" \
        --replace-fail "include/linux/user.h" ""
    '';

    meta = {
      description = "Raspberry Pi Pico Random Number Generator";
      homepage = "https://github.com/polhenarejos/pico-rng";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [];
      mainProgram = "pico-rng";
      platforms = lib.platforms.all;
    };
  }
