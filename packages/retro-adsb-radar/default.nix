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
    rev = "840f1e9e8aefb632cbf17edc2a666403b3a3a602";
    hash = "sha256-S/0ssh9v0nSUW+UaIpIF8AQF5hKG7BevOk+BJIaPhtI=";
  };

  patches = [./fonts.patch];

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
