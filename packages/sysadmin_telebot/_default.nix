{
  pkgs,
  lib,
  pdm,
  python310Packages,
  fetchFromGitHub,
  inputs,
  writeShellScriptBin,
}:
#  let
#   poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix {inherit pkgs;};
# in
#   poetry2nix.mkPoetryApplication {
#     projectDir = fetchFromGitHub {
#       owner = "gregdan3";
#       repo = "server-administration-bot";
#       rev = "5a60b448d3d9864ebfef7de22e6903fa77aee0fb";
#       sha256 = "sha256-H8yhEMppfkt0l9bn3w9BkwniQiK9FFNKhbXMaYczTzw=";
#     };
#   }
with python310Packages; let
  module = buildPythonPackage rec {
    pname = "sysadmin_telebot";
    version = "0.0.1";
    # format = "pyproject";
    pyproject = true;
    src = fetchFromGitHub {
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
      telegram
    ];
    doCheck = false;
    # meta = with lib; {
    #   homepage = "https://github.com/mkdocstrings/autorefs";
    #   description = "Automatically link across pages in MkDocs.";
    #   license = licenses.isc;
    # };
  };
in
  writeShellScriptBin "sysadmin_telebot" ''
    ${python.interpreter} ${module}/lib/python3.10/site-packages/sysadmin_telebot/main.py
  ''
