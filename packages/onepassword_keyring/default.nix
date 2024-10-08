{
  python3Packages,
  fetchFromGitHub,
  _1password,
}:
with python3Packages;
  buildPythonApplication rec {
    pname = "onepassword_keyring";
    version = "unstable-2023-12-20";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "falling-springs";
      repo = "onepassword-keyring";
      rev = "bffdc609a0a99a6c172add026cb500dc8331ce44";
      hash = "sha256-Yu8TLg4Y6gRj59E7YWMxN20LSxROGsWiOqRUkDlnQ/I=";
    };

    nativeBuildInputs = [
      python3Packages.setuptools
      python3Packages.wheel
    ];

    propagatedBuildInputs = [
      keyring
      _1password
    ];

    pythonImportsCheck = ["onepassword_keyring"];

    meta = with lib; {
      description = "Implementation of 1Password as keyring backend";
      homepage = "https://github.com/falling-springs/onepassword-keyring";
      license = licenses.mit;
      maintainers = with maintainers; [];
      mainProgram = "onepassword_keyring";
    };
  }
