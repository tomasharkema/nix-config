{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "flipperzero-ufbt";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flipperdevices";
    repo = "flipperzero-ufbt";
    rev = "v${version}";
    hash = "sha256-PhuUzw/szzPakxgDf/7DYiL7reMGoFrG4CiOa2bBGd4=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-git-versioning
  ];

  dependencies = with python3.pkgs; [
    oslex
  ];

  pythonImportsCheck = [
    "ufbt"
  ];

  meta = {
    description = "Compact tool for building and debugging applications for Flipper Zero";
    homepage = "https://github.com/flipperdevices/flipperzero-ufbt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "flipperzero-ufbt";
  };
}
