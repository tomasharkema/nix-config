{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "pyobd";
  version = "1.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "barracuda-fsh";
    repo = "pyobd";
    rev = "v${version}";
    hash = "sha256-MkuMUqmYBq+xd7mtgzbBxVlunywpTdZgkcoJKnhh6oI=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    numpy
    pillow
    pint
    pyserial
    six
    tornado
    wxpython
  ];

  pythonImportsCheck = [
    "pyobd2"
  ];

  meta = {
    description = "An OBD-II compliant car diagnostic tool";
    homepage = "https://github.com/barracuda-fsh/pyobd";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "pyobd";
  };
}
