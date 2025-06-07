{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
}:
stdenv.mkDerivation rec {
  pname = "sscom";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "kent0628";
    repo = "sscom";
    rev = "v${version}";
    hash = "sha256-Q+tVMDaDo7r1KwW6WLrFsyZK6nBCnVSVXYaD0dXZy90=";
  };

  nativeBuildInputs = with libsForQt5; [
    qt5.qtbase
    qt5.full
    qt5.wrapQtAppsHook
    qt5.qmake
  ];

  postInstall = ''
    ls -la
    mkdir -p $out/bin
    cp sscom $out/bin
  '';

  meta = {
    description = "Linux sscom";
    homepage = "https://github.com/kent0628/sscom";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [];
    mainProgram = "sscom";
    platforms = lib.platforms.all;
  };
}
