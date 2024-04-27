{
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "rmfuse";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lPce8tiqIPyZgbCgAxiADca+JRjUzYLDfA0tf1SQftI=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    # tornado
    # python-daemon
    bidict
    pyfuse3
    rmcl
    rmrl
  ];
}
