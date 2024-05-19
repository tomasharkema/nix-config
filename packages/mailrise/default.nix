{ stdenv, fetchFromGitHub, python3, apprise, python3Packages, }:
python3Packages.buildPythonApplication rec {

  pname = "mailrise";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "YoRyan";
    repo = "mailrise";
    rev = version;
    hash = "sha256-QgeGDQeSsfvopgBgQQsWrx036SX1FhE67LI8M8rJM/Q=";
  };

  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    setuptools
    wheel
    # poetry-core
    aiosmtpd
    pyyaml
    apprise
  ];

  buildInputs = with python3Packages; [ aiosmtpd pyyaml apprise ];
}
