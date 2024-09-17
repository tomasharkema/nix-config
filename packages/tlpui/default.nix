{
  lib,
  python3,
  fetchFromGitHub,
  tlp,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "tlpui";
  version = "1.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "d4nj1";
    repo = "TLPUI";
    rev = "tlpui-${version}";
    hash = "sha256-pgzGhf2WDRNQ2z0hPapUJA5MLTKq92UlgjC+G78T/4s=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pyyaml
    tlp
  ];

  # pythonImportsCheck = ["tlp_ui"];

  meta = with lib; {
    description = "A GTK user interface for TLP written in Python";
    homepage = "https://github.com/d4nj1/TLPUI";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [];
    mainProgram = "tlpui";
  };
}
