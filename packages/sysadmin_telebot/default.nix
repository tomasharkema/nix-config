{
  pkgs,
  lib,
  pdm,
  python310Packages,
}:
with python310Packages;
  buildPythonApplication rec {
    pname = "sysadmin_telebot";
    version = "0.4.1";
    format = "pyproject";

    src = pkgs.fetchFromGitHub {
      owner = "gregdan3";
      repo = "server-administration-bot";
      rev = "5a60b448d3d9864ebfef7de22e6903fa77aee0fb";
      sha256 = "sha256-H8yhEMppfkt0l9bn3w9BkwniQiK9FFNKhbXMaYczTzw=";
    };

    nativeBuildInputs = [
      pdm
      pdm-pep517
    ];
    propagatedBuildInputs = [
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
