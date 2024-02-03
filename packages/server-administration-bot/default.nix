{
  lib,
  pdm,
  python3,
  python3Packages,
  fetchFromGitHub,
}: let
  python = python3.withPackages (ps: with ps; [telegram]);
in
  python.pkgs.buildPythonApplication rec {
    pname = "server-administration-bot";
    version = "0.0.1";
    # format = "pyproject";
    pyproject = true;

    src = fetchFromGitHub {
      repo = "server-administration-bot";
      owner = "gregdan3";
      rev = "5a60b448d3d9864ebfef7de22e6903fa77aee0fb";
      sha256 = "sha256-H8yhEMppfkt0l9bn3w9BkwniQiK9FFNKhbXMaYczTzw=";
    };

    nativeBuildInputs = [pdm];
    propagatedBuildInputs = with python.pkgs; [
      pdm
      wheel
      pdm-pep517

      setuptools
      # markdown
      # mkdocs
    ];

    doCheck = false;

    # meta = with lib; {
    #   homepage = "https://github.com/mkdocstrings/autorefs";
    #   description = "Automatically link across pages in MkDocs.";
    #   license = licenses.isc;
    # };
  }
