{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "nixstatsagent";
  version = "1.2.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nixstats";
    repo = "nixstatsagent";
    rev = "v${version}";
    hash = "sha256-2lYKwbIHcQMqfjH7Dlr945KjYoY48Yufc7kQ5LH9lAA=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  #passthroughBuildInputs
  buildInputs = with python3Packages; [
    psutil
    netifaces
    configparser
    future
    distro
    imp
  ];

  pythonImportsCheck = ["nixstatsagent"];

  meta = with lib; {
    description = "NIXStats monitoring agent";
    homepage = "https://github.com/Nixstats/nixstatsagent";
    license = licenses.bsd3;
    maintainers = with maintainers; [];
    mainProgram = "nixstatsagent";
  };
}
