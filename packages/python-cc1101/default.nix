{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "python-cc1101";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fphammerle";
    repo = "python-cc1101";
    rev = "v${version}";
    hash = "sha256-eS0aQx/SqjzmsHszJOGB6kqkuXRi5x4oE9vpUxkrGfo=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
    python3.pkgs.wheel
  ];

  dependencies = [python3.pkgs.spidev];

  pythonImportsCheck = [
    # "python_cc1101"
  ];

  meta = {
    description = "Python Library & Command Line Tool to Transmit RF Signals via CC1101 Transceivers";
    homepage = "https://github.com/fphammerle/python-cc1101";
    changelog = "https://github.com/fphammerle/python-cc1101/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "python-cc1101";
  };
}
