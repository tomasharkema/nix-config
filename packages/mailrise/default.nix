{
  stdenv,
  fetchFromGitHub,
  apprise,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "mailrise";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "YoRyan";
    repo = "mailrise";
    rev = "main";
    hash = "sha256-CG/tYbzy1E6eQ5fW9htqLyvzc32GzlSm1UVn3nuteIg=";
  };

  pyproject = true;
  build-system = [python3Packages.setuptools];

  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    setuptools
    setuptools-scm
    # wheel
    # poetry-core
    aiosmtpd
    pyyaml
    apprise
  ];

  buildInputs = with python3Packages; [aiosmtpd pyyaml apprise];
}
