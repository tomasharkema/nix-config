{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "hwinfo-tui";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JuanjoFuchs";
    repo = "hwinfo-tui";
    rev = "v${version}";
    hash = "sha256-nPDEMcpMfHLi2Q0DHDwMgHjRvjKyaE58Svxc0F43pA4=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    pandas
    plotext
    rich
    toml
    typer
    watchdog
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      black
      build
      importlib-metadata
      mypy
      pandas-stubs
      pre-commit
      pyinstaller
      pytest
      pytest-cov
      ruff
      twine
      types-toml
    ];
  };

  pythonImportsCheck = [
    "hwinfo_tui"
  ];

  meta = {
    description = "A gping-inspired terminal visualization tool for monitoring real-time hardware sensor data from HWInfo";
    homepage = "https://github.com/JuanjoFuchs/hwinfo-tui";
    changelog = "https://github.com/JuanjoFuchs/hwinfo-tui/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "hwinfo-tui";
  };
}
