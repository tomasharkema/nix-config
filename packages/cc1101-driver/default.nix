{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  kernel ? pkgs.linuxPackages_latest.kernel,
}: let
  buildFolder = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
  stdenv.mkDerivation rec {
    pname = "cc1101-driver";
    version = "unstable-2022-09-23-${kernel.version}";

    src = fetchFromGitHub {
      owner = "gherlein"; # "28757B2";
      repo = "cc1101-driver";
      rev = "368b67f6e991039b66b5943bceaf5990641d09a2";
      hash = "sha256-uugUfWrW2TWBX6JXf5Ql6WKx+VaR2aHRdmCHgNA4j3Y=";
    };

    patches = [./kernel.patch];

    # postPatch = ''
    #   echo "${buildFolder}"
    #   substituteInPlace Makefile \
    #     --replace-fail '-C /lib/modules/$(shell uname -r)/build' '-C ${buildFolder}'
    # '';

    nativeBuildInputs = kernel.moduleBuildDependencies;

    makeFlags = ["KDIR=${buildFolder}"];

    installPhase = ''
      runHook preInstall

      install -D cc1101.ko $out/lib/modules/${kernel.modDirVersion}/updates/cc1101.ko

      runHook postInstall
    '';

    meta = {
      description = "Linux device driver for the Texas Instruments CC1101 radio";
      homepage = "https://github.com/28757B2/cc1101-driver";
      license = lib.licenses.gpl2Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "cc1101-driver";
      platforms = lib.platforms.all;
    };
  }
