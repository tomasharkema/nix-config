{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  qt6,
  libusb1,
  fftw,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "OpenHantek";
  version = "3.4.1-rc2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OpenHantek";
    repo = "OpenHantek6022";
    tag = finalAttrs.version;
    hash = "sha256-5QdbannyNrPPekJkLuHs67N/BOGVMXUhGqrLKJ6Z/Sg=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    libusb1
    fftw
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "OpenHantek6022 is a DSO software for Hantek USB digital signal oscilloscopes 6022BE / BL. Development OS is Debian Linux, but the program also works on FreeBSD, MacOS, RaspberryPi and Windows. No support for non-Linux related issues unless a volunteer steps in";
    homepage = "https://github.com/OpenHantek/OpenHantek6022";
    changelog = "https://github.com/OpenHantek/OpenHantek6022/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "OpenHantek";
    platforms = lib.platforms.all;
  };
})
