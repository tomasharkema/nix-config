{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonPackage rec {
  pname = "lesscpy";
  version = "0.15.1";
  pyproject = true;
  #format = "setuptools";
  src = fetchFromGitHub {
    owner = "lesscpy";
    repo = "lesscpy";
    rev = "2fb98b4f04183916cf7fb75c9947fb26bc904fc6";
    hash = "sha256-pR9JrsVZyLAzcGVG89pEA/OHEg7plT3gK+up5YzKbj8=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
    distlib
    distutils-extra
  ];

  dependencies = with python3Packages; [
    ply
    six
    wheel
    distlib
    distutils-extra
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    wheel
    distlib
    distutils-extra
  ];
  pythonImportsCheck = ["lesscpy"];

  meta = {
    description = "Python LESS Compiler";
    mainProgram = "lesscpy";
    homepage = "https://github.com/lesscpy/lesscpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [s1341];
  };
}
