{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "sbm69";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ignisf";
    repo = "sbm69";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IjNfVIOkbEctb34Or5NPiuD0RrevQY/4QEetyii9y+0=";
  };

  build-system = [
    python3.pkgs.flit
  ];

  dependencies = with python3.pkgs; [
    bleak
    bleak-retry-connector
    construct
    inflection
  ];

  optional-dependencies = with python3.pkgs; {
    test = [
      bandit
      black
      check-manifest
      flake8
      flake8-bugbear
      flake8-docstrings
      flake8-formatter-junit-xml
      pre-commit
      pylint
      pylint-junit
      shellcheck-py
    ];
  };

  pythonImportsCheck = [
    "sbm69"
  ];

  meta = {
    description = "A library to retrieve blood pressure measurements from the SilverCrest® SBM69 Bluetooth Blood Pressure Monitor";
    homepage = "https://github.com/ignisf/sbm69";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "sbm69";
  };
})
