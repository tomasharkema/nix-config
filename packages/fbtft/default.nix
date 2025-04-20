{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
  kernel ? pkgs.linuxPackages_latest.kernel,
}:
stdenv.mkDerivation rec {
  pname = "fbtft";
  version = "unstable-2021-08-15";

  src = fetchFromGitHub {
    owner = "notro";
    repo = "fbtft";
    rev = "e9fc10a080a6c52e46e004c4c2bc9fd3cf3d7445";
    hash = "sha256-/RFD7vqwT+BDWUXK0V0wuHNVNHptq3QkaGDtBe5Ulcg=";
  };
  postPatch = ''cp ${./.config} ./.config'';
  preBuild = ''cat .config'';
  nativeBuildInputs = kernel.moduleBuildDependencies; # 2

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}" # 3
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # 4
    "INSTALL_MOD_PATH=$(out)" # 5
    "CONFIG_FB_TFT_TINYLCD=y"
  ];

  meta = {
    description = "Linux Framebuffer drivers for small TFT LCD display modules. Development has moved to https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/tree/drivers/staging/fbtft?h=staging-testing";
    homepage = "https://github.com/notro/fbtft";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "fbtft";
    platforms = lib.platforms.all;
  };
}
