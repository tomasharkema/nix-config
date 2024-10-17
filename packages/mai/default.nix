{
  lib,
  python3,
  fetchFromGitHub,
  xcparse,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "mai";
  version = "unstable-2015-03-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "samdmarshall";
    repo = "Mai";
    rev = "d38db41bda6447240b4dbbee0677a2d332a0195a";
    hash = "sha256-5E0jrsZbSTvFBfOSCoE0IB65jkVXaSsGw3ZZL81ehag=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  buildInputs = [xcparse];

  pythonImportsCheck = ["mai"];

  meta = with lib; {
    description = "Xcodebuild wrapper";
    homepage = "https://github.com/samdmarshall/Mai";
    license = licenses.bsd3;
    maintainers = with maintainers; [];
    mainProgram = "mai";
  };
}
