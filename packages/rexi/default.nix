{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
}: let
  textual52 = python3.pkgs.textual.overrideAttrs (old: rec {
    version = "0.52.1";
    src = fetchPypi {
      inherit version;
      pname = old.pname;
      sha256 = "sha256-QjLlwrQj7Xxjuq62AwNV4U4d4bnfCWyWVbaKHmDk3l8=";
    };
    doCheck = false;
  });
in
  python3.pkgs.buildPythonApplication rec {
    pname = "rexi";
    version = "1.2.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "royreznik";
      repo = "rexi";
      rev = "v${version}";
      hash = "sha256-tag2/QTM6tDCU3qr4e1GqRYAZgpvEgtA+FtR4P7WdiU=";
    };

    build-system = [
      python3.pkgs.poetry-core
    ];

    dependencies = with python3.pkgs; [
      colorama
      textual52
      typer
    ];

    pythonImportsCheck = [
      "rexi"
    ];

    meta = {
      description = "Terminal UI for Regex Testing";
      homepage = "https://github.com/royreznik/rexi";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [];
      mainProgram = "rexi";
    };
  }
