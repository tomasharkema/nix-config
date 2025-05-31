{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "tmd-top";
  version = "unstable-2024-12-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CDWEN0526";
    repo = "tmd-top";
    rev = "b0de671271f80318cd8fbb7aefd8214d7405d94a";
    hash = "sha256-GMGUEU7O4uwoHNzUlsbsl7ec0cXx59Z0yUNHlK6PHLg=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    geoip2
    rich
    textual
    typing-extensions
  ];

  pythonImportsCheck = [
    "tmd_top"
  ];

  meta = {
    description = "Real-time monitoring of Linux process network traffic, including the client IP, port, and transfer speed for each connection";
    homepage = "https://github.com/CDWEN0526/tmd-top";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [];
    mainProgram = "tmd-top";
  };
}
