{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  makeDesktopItem,
  copyDesktopItems,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "retro-adsb-radar";
  version = "unstable-2025-11-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nicespoon";
    repo = "retro-adsb-radar";
    rev = "31e70a08d3ed2cd391c542769bb2a52e60b888a8";
    hash = "sha256-r2M7PzX8tzzl5ZuCm89Ev0pyVwCVQwyIiJUh+4OiCW4=";
  };

  # patches = [
  #   ./fonts.patch
  # ];

  desktopItems = [
    (makeDesktopItem {
      name = "retro-adsb-radar";
      desktopName = "retro-adsb-radar";
      exec = "retro-adsb-radar";
    })
  ];

  postPatch = ''
    mkdir src
    mv *.py ./src/
    mv fonts ./src/
    mv images ./src/
    cp ${./pyproject.toml} ./pyproject.toml
  '';

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    setuptools
    pygame
    python-vlc
    requests
  ];

  nativeBuildItems = [copyDesktopItems];

  meta = {
    description = "Aircraft radar display with retro styling. Visualises real-time aircraft positions and information from an ADS-B feed";
    homepage = "https://github.com/nicespoon/retro-adsb-radar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "retro-adsb-radar";
    platforms = lib.platforms.all;
  };
}
