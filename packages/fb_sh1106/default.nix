{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  kernel ? pkgs.linuxPackages_latest.kernel,
  kmod,
}:
stdenv.mkDerivation rec {
  pname = "fb-sh1106";
  version = "unstable-2017-12-11";

  src = fetchFromGitHub {
    owner = "claydonkey";
    repo = "fb_sh1106";
    rev = "57360d5d0014434505ea2f723066823cea3219db";
    hash = "sha256-WFnyjcj2/aix76deTLJH8Yj9mMlKxMab2FvXTVXT/5E=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace-fail "make -C /lib/modules/" "make -C ${kernel.dev}/lib/modules/"

    substituteInPlace fbtft.h --replace-fail "static int fbtft_driver_remove_pdev(struct" "static void fbtft_driver_remove_pdev(struct"
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies; # 2

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}" # 3
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # 4
    "INSTALL_MOD_PATH=$(out)" # 5
  ];

  meta = {
    description = "SH1106 oled linux device tree overlay and kernel module for 32 RASPI kernels 4.9.x";
    homepage = "https://github.com/claydonkey/fb_sh1106";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "fb-sh1106";
    platforms = lib.platforms.all;
  };
}
