{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "tewi";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anlar";
    repo = "tewi";
    rev = "v${version}";
    hash = "sha256-tCbfpuiV/Conxf1SoRc014+55eLSMEaxfbXecrrqEHU=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    textual
    transmission-rpc
  ];

  postPatch = with python3.pkgs; ''
    substituteInPlace pyproject.toml \
      --replace-fail "transmission-rpc == 7.0.11" "transmission-rpc == ${transmission-rpc.version}" \
      --replace-fail "textual == 0.83.0" "textual == ${textual.version}"
  '';

  pythonImportsCheck = ["tewi"];

  meta = with lib; {
    description = "Text-based interface for the Transmission BitTorrent daemon";
    homepage = "https://github.com/anlar/tewi";
    changelog = "https://github.com/anlar/tewi/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
    mainProgram = "tewi";
  };
}
