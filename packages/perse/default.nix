{
  lib,
  stdenv,
  fetchFromGitHub,
  qt5,
}:
stdenv.mkDerivation rec {
  pname = "perse";
  version = "1.0.3-ubuntu20.04";

  src = fetchFromGitHub {
    owner = "vranki";
    repo = "perse";
    rev = version;
    hash = "sha256-HroljD3xjXLOYRB0nahkOqj4PT4koZoewAz+yo63eV4=";
  };

  buildInputs = [qt5.qtbase];
  nativeBuildInputs = [qt5.wrapQtAppsHook qt5.qmake];

  postPatch = ''
    ls -la

    substituteInPlace src/src.pro --replace-fail "/usr" "$out" \
      --replace-fail "/lib" "$out/lib"

  '';

  # buildPhase = ''
  #   qmake
  #   make
  #'';

  meta = {
    description = "Permission settings manager GUI for Linux UDev";
    homepage = "https://github.com/vranki/perse";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "perse";
    platforms = lib.platforms.all;
  };
}
