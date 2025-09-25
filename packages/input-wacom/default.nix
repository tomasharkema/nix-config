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
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "input-wacom";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "input-wacom";
    rev = "v${version}";
    hash = "sha256-Rk0SWCiCFOIkvPRZKPaes0x4+kYoWnrFlcWZU8DSJFE=";
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

  configureFlags = [
    "--with-kernel=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "--with-kernel-version=${kernel.modDirVersion}"
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
    cp /build/source/4.18/*.ko $out/lib/modules/${kernel.modDirVersion}/extra
  '';
  passthru = {
    updateScript = nix-update-script {};
  };
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
