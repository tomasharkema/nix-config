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
    pname = "i2c-ch341-usb";
    version = "1.0";

    src = fetchFromGitHub {
      owner = "gschorcht";
      repo = "i2c-ch341-usb";
      rev = "v${version}";
      hash = "sha256-MnwJ1ucRxv9DhTEbIXS6UVg+xsCcKGOxovIlv8mqT+I=";
    };
    nativeBuildInputs = kernel.moduleBuildDependencies;

    makeFlags = ["KDIR=${buildFolder}" "KERNEL_DIR=${buildFolder}"];

    installPhase = ''
      runHook preInstall

      install -D i2c-ch341-usb.ko $out/lib/modules/${kernel.modDirVersion}/updates/i2c-ch341-usb.ko

      runHook postInstall
    '';

    meta = {
      description = "A Linux kernel driver for ch341 emulating the I2C bus";
      homepage = "https://github.com/gschorcht/i2c-ch341-usb";
      license = lib.licenses.unfree; # FIXME: nix-init did not find a license
      maintainers = with lib.maintainers; [];
      mainProgram = "i2c-ch341-usb";
      platforms = lib.platforms.all;
    };
  }
