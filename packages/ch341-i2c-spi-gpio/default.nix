{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  kernel ? pkgs.linuxPackages_latest.kernel,
}: let
  buildFolder = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  outputFolder = "${placeholder "out"}/lib/modules/${kernel.modDirVersion}/updates/";
in
  stdenv.mkDerivation rec {
    pname = "ch341-i2c-spi-gpio";
    version = "unstable-2025-04-12";

    src = fetchFromGitHub {
      owner = "frank-zago";
      repo = "ch341-i2c-spi-gpio";
      rev = "bf0a27ca1cf0335d1a0623c38bf41c5ba8da3658";
      hash = "sha256-6nrl05ykatGYiX3SlgJ14BdO40qi18EQJZB8H21fk+g=";
    };

    nativeBuildInputs = kernel.moduleBuildDependencies;

    makeFlags = ["KDIR=${buildFolder}" "KERNEL_DIR=${buildFolder}"];

    installPhase = ''
      runHook preInstall

      install -D ch341-core.ko ${outputFolder}/ch341-core.ko
      install -D i2c-ch341.ko ${outputFolder}/i2c-ch341.ko
      install -D gpio-ch341.ko ${outputFolder}/gpio-ch341.ko
      install -D spi-ch341.ko ${outputFolder}/spi-ch341.ko

      runHook postInstall
    '';

    patches = [./linux-17.patch];

    meta = {
      description = "WinChipHead CH341 linux driver for I2C, SPI and GPIO mode";
      homepage = "https://github.com/frank-zago/ch341-i2c-spi-gpio";
      license = lib.licenses.gpl2Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "ch341-i2c-spi-gpio";
      platforms = lib.platforms.all;
    };
  }
