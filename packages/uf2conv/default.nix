{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "uf2conv";
  version = "unstable-2024-11-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "makerdiary";
    repo = "uf2utils";
    rev = "cca4fe551e4253af481f1b5fd6a1d6844899c2da";
    hash = "sha256-dKavkVWyryIrYYgb7BB2QTTanCxGE6mmLoz1k5aFJxY=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = [
    "uf2conv"
  ];

  meta = {
    description = "An open source Python based tool for packing and unpacking UF2 files";
    homepage = "https://github.com/makerdiary/uf2utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "uf2conv";
  };
}
