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
    pname = "ch34x";
    version = "unstable-2025-04-12";

    src = fetchFromGitHub {
      owner = "juliagoda";
      repo = "CH341SER";
      rev = "70d8d643b6ff855d1743cd42a8068c4fe82dc4ad";
      hash = "sha256-yxgJbIH6MKmx4gsabiurDoa9WyvDK88s4LTu/VoBgs8=";
    };

    nativeBuildInputs = kernel.moduleBuildDependencies;

    makeFlags = ["KDIR=${buildFolder}" "KERNEL_DIR=${buildFolder}" "KERNELDIR=${buildFolder}"];

    installPhase = ''
      runHook preInstall

      install -D ch34x.ko $out/lib/modules/${kernel.modDirVersion}/serial/ch34x.ko

      runHook postInstall
    '';

    # meta = {
    #   description = "WinChipHead CH341 linux driver for I2C, SPI and GPIO mode";
    #   homepage = "https://github.com/frank-zago/ch341-i2c-spi-gpio";
    #   license = lib.licenses.gpl2Only;
    #   maintainers = with lib.maintainers; [];
    #   mainProgram = "ch341-i2c-spi-gpio";
    #   platforms = lib.platforms.all;
    # };
  }
