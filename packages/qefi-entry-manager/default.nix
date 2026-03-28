{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qefi-entry-manager";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Inokinoki";
    repo = "QEFIEntryManager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PKGPwkBhtV/EsmDDua9BA/gc4i94F3VG9HhnUlFP1qg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  meta = {
    description = "A userspace cross-platform EFI boot entry and EFI partition management GUI App based on Qt";
    homepage = "https://github.com/Inokinoki/QEFIEntryManager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "qefi-entry-manager";
    platforms = lib.platforms.all;
  };
})
