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
    pname = "ch341-i2c-spi-gpio";
    version = "unstable-2025-04-12";

    src = fetchFromGitHub {
      owner = "frank-zago";
      repo = "ch341-i2c-spi-gpio";
      rev = "b80a9c375d9e00aaf69610c3826d00ce526a0d69";
      hash = "sha256-EN2AkauuwUE6haV6a5W6VvK0Pyj5WgS8nq3Cr2ctyoo=";
    };

    nativeBuildInputs = kernel.moduleBuildDependencies;

    makeFlags = ["KDIR=${buildFolder}" "KERNEL_DIR=${buildFolder}"];

    installPhase = ''
      runHook preInstall

      install -D ch341-core.ko $out/lib/modules/${kernel.modDirVersion}/updates/ch341-core.ko
      install -D i2c-ch341.ko $out/lib/modules/${kernel.modDirVersion}/updates/i2c-ch341.ko
      install -D gpio-ch341.ko $out/lib/modules/${kernel.modDirVersion}/updates/gpio-ch341.ko
      install -D spi-ch341.ko $out/lib/modules/${kernel.modDirVersion}/updates/spi-ch341.ko

      runHook postInstall
    '';

    meta = {
      description = "WinChipHead CH341 linux driver for I2C, SPI and GPIO mode";
      homepage = "https://github.com/frank-zago/ch341-i2c-spi-gpio";
      license = lib.licenses.gpl2Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "ch341-i2c-spi-gpio";
      platforms = lib.platforms.all;
    };
  }
