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
  # kernelCombi = pkgs.stdenv.mkDerivation {
  #   name = "${kernel.modDirVersion}-combi";
  #   phases = ["buildPhase"];
  #   buildPhase = ''
  #     temp=`mktemp -d`
  #     cp -r ${kernelBuild}/source/* $temp
  #     chmod 777 -R $temp
  #     cp -r ${kernelBuild}/build/include/config $temp/include
  #     chmod 777 -R $temp
  #     cp -r $temp $out
  #     rm -rf $temp
  #   '';
  # };

  makefile = pkgs.writeText "Makefile" ''
    KERNELRELEASE ?= $(shell uname -r)
    KERNEL_DIR  ?= /lib/modules/$(KERNELRELEASE)/build
    PWD := $(shell pwd)

    obj-m := pico_rng.o

    all:
    	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) modules

    install:
    	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) modules_install

    clean:
    	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) clean

  '';
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

    patches = [./update.patch];

    postPatch = ''
      cp ${makefile} ./Makefile
    '';

    nativeBuildInputs =
      [
        # cmake
      ]
      ++ kernel.moduleBuildDependencies;

    makeFlags = [
      "KERNELRELEASE=${kernel.modDirVersion}" # 3
      "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # 4
      "INSTALL_MOD_PATH=$(out)" # 5
    ];

    # cmakeFlags = [
    #   "-DKERNEL_RELEASE=${kernel.modDirVersion}"
    #   "-DKERNELHEADERS_DIR=${kernelCombi}"
    #   "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    #   # "--debug-output"
    # ];

    # makeFlags = [
    #   # "-d"
    #   "KERNELRELEASE=${kernel.modDirVersion}"
    #   "KERNEL_DIR=${kernelCombi}"
    #   "INSTALL_MOD_PATH=${placeholder "out"}"
    #   "CMAKE_INSTALL_PREFIX=${placeholder "out"}"
    #   "KERNELHEADERS_DIR=${kernelCombi}"
    # ];

    # postPatch = ''
    #   substituteInPlace CMakeLists.txt \
    #     --replace-fail '/usr/src/linux-headers-''${KERNEL_RELEASE}' "${kernelCombi}" \
    #     --replace-fail "COMMAND uname -r" "COMMAND echo ${kernel.modDirVersion}"
    # '';
    # \
    #     --replace-fail "include/linux/user.h" ""

    meta = {
      description = "Raspberry Pi Pico Random Number Generator";
      homepage = "https://github.com/polhenarejos/pico-rng";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [];
      mainProgram = "pico-rng";
      platforms = lib.platforms.all;
    };
  }
