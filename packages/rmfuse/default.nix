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

  # doCheck = false;

  # nativeBuildInputs = [
  #   pdm-pep517
  #   pep517
  # ];

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
  ];
}
# {
#   lib,
#   python310Packages,
#   fetchFromGitHub,
# }:
# python310Packages.buildPythonApplication rec {
#   pname = "rmfuse";
#   version = "0.2.3";
#   pyproject = true;
#   src = fetchFromGitHub {
#     owner = "rschroll";
#     repo = "rmfuse";
#     rev = "v${version}";
#     hash = "sha256-Esm2UmvTJk8rOL5LxvBmsLtkbh9h15DaqG8hpAdhk6o=";
#   };
# }

