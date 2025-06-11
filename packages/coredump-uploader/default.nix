{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "coredump-uploader";
  version = "unstable-2021-04-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "coredump-uploader";
    rev = "d8a7fd2ef4d5e8ec77e747059332fd0919c2a980";
    hash = "sha256-Y6pkE/tDsb384fz332ByRJM5ErLSQKq2GygAbozbaGc=";
  };

  build-system = [
    # python3.pkgs.poetry
    python3.pkgs.poetry-core
  ];

  dependencies = with python3.pkgs; [
    click
    sentry-sdk
    watchdog
  ];

  pythonImportsCheck = [
    "coredump_uploader"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry>=0.12" poetry-core \
      --replace-fail "poetry.masonry.api" "poetry.core.masonry.api" \
      --replace-fail "click = \"^7.0\"" "click = \"^8.0\"" \
      --replace-fail "sentry-sdk = \"^1.0.0\"" "sentry-sdk = \"^2.0.0\"" \
      --replace-fail "watchdog = \"^0\"" "watchdog = \"^6\""
  '';

  meta = {
    description = "Coredump uploader";
    homepage = "https://github.com/getsentry/coredump-uploader";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "coredump-uploader";
  };
}
