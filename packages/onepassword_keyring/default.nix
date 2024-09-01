{
  python3Packages,
  fetchFromGitHub,
}:
with python3Packages;
  buildPythonApplication rec {
    pname = "onepassword_keyring";
    version = "0.0.1";

    src = fetchFromGitHub {
      owner = "falling-springs";
      repo = "onepassword-keyring";
      rev = "bffdc609a0a99a6c172add026cb500dc8331ce44";
      hash = "sha256-Yu8TLg4Y6gRj59E7YWMxN20LSxROGsWiOqRUkDlnQ/I=";
    };

    doCheck = false;

    build-system = [
      setuptools
      setuptools-scm
    ];

    propagatedBuildInputs = [
      keyring
    ];

    nativeBuildInputs = [
      poetry-core
      # wheel
    ];
  }
