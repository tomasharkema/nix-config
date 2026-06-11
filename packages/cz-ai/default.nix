{
  lib,
  python3,
  fetchFromGitHub,
  commitizen,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "cz-ai";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "watadarkstar";
    repo = "cz_ai";
    tag = finalAttrs.version;
    hash = "sha256-ABSKcElWSGV3tB+OSAEQc/uAofSC2zGxGq4b77IBMn8=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    commitizen
  ];

  # pythonImportsCheck = [
  #   "cz_cz_ai"
  # ];

  meta = {
    description = "A Commitizen plugin that leverages OpenAI's GPT-4o to automatically generate clear, concise, and conventional commit messages based on your staged git changes";
    homepage = "https://github.com/watadarkstar/cz_ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "cz-ai";
  };
})
