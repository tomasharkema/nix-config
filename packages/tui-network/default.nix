{
  lib,
  python3,
  fetchFromGitHub,
  fortune,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "tui-network";
  version = "unstable-2025-01-02";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Zatfer17";
    repo = "tui-network";
    rev = "e1c932daf532805b522201383984da4a29e156fe";
    hash = "sha256-JfgUvgQ0eGqt/l6JN6Tfmtr0tVbbbNKJzv+RFIyEhMs=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    fortune
    textual
  ];

  pythonImportsCheck = [
    "tui_network"
  ];

  meta = {
    description = "";
    homepage = "https://github.com/Zatfer17/tui-network";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "tui-network";
  };
}
