{
  lib,
  python3,
  fetchFromGitHub,
  soapysdr-with-plugins,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "hamrf";
  version = "0-unstable-2025-11-13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "punk-kaos";
    repo = "hamrf";
    rev = "2361f9c005e42e90a95122d862ff92a9a139c445";
    hash = "sha256-ylOyTcYTbY7stRSL6/+ovkuDfFjMRdf/f3jZzY5SIzQ=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    numpy
    pyserial
    pyyaml
    scipy
    soapysdr-with-plugins
    sounddevice
    typer
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      black
      mypy
      pytest
      pytest-cov
      ruff
    ];
  };

  pythonImportsCheck = [
    "hamrf"
  ];

  buildInputs = [
    soapysdr-with-plugins
  ];

  meta = {
    description = "Virtual rig to use the HackRF with ham digimodes";
    homepage = "https://github.com/punk-kaos/hamrf";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "hamrf";
  };
})
