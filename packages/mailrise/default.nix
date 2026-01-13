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
    rev = "60d485e2ae22ae09ddeac25565c48e3455a8c1a7";
    hash = "sha256-CG/tYbzy1E6eQ5fW9htqLyvzc32GzlSm1UVn3nuteIg=";
  };

  pyproject = true;
  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    setuptools
    setuptools-scm
    # wheel
    # poetry-core
    aiosmtpd
    pyyaml
    apprise
  ];

  buildInputs = with python3Packages; [
    aiosmtpd
    pyyaml
    apprise
  ];
}
