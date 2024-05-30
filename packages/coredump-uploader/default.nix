{ lib, python3Packages, fetchFromGitHub,

}:
with python3Packages;
buildPythonApplication rec {
  pname = "coredump-uploader";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "coredump-uploader";
    rev = "d8a7fd2ef4d5e8ec77e747059332fd0919c2a980";
    sha256 = "sha256-Y6pkE/tDsb384fz332ByRJM5ErLSQKq2GygAbozbaGc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>="
  '';

  nativeBuildInputs = [ poetry-core setuptools-scm watchdog click sentry-sdk ];
}
