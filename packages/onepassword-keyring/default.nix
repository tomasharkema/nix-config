{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "onepassword-keyring";
  version = "unstable-2025-04-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "falling-springs";
    repo = "onepassword-keyring";
    rev = "d8f67e18ee88f66a3c014e66e8af7cc14d07043f";
    hash = "sha256-7bXMy+EcT4jskCEdRtbZ07y4K5PXZDHctIwUUj/S5ys=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    keyring
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      pytest
      pytest-cov
      pytest-mock
      ruff
    ];
  };

  pythonImportsCheck = [
    "onepassword_keyring"
  ];

  meta = {
    description = "Implementation of 1Password as keyring backend";
    homepage = "https://github.com/falling-springs/onepassword-keyring";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "onepassword-keyring";
  };
}
