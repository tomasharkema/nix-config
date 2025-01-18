{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoconf,
  automake,
  autoreconfHook,
  autoPatchelfHook,
  linuxPackages,
  kernel ? linuxPackages.kernel,
  kmod,
}:
stdenv.mkDerivation rec {
  pname = "input-wacom";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "input-wacom";
    rev = "v${version}";
    hash = "sha256-p2XLW92i4CVuev2eM6uQQykWKa7lm+/lBdOptoD9YNU=";
  };

  nativeBuildInputs =
    [
      pkg-config
      autoconf
      automake
      autoreconfHook
      autoPatchelfHook
    ]
    ++ kernel.moduleBuildDependencies;

  makeFlags = [
    "WCM_KERNEL_VER=${kernel.modDirVersion}"
    "WCM_KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = {
    description = "Linux kernel driver for Wacom devices";
    homepage = "https://github.com/linuxwacom/input-wacom";
    changelog = "https://github.com/linuxwacom/input-wacom/blob/${src.rev}/ChangeLog";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "input-wacom";
    platforms = lib.platforms.all;
  };
}
