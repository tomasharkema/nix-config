# https://github.com/pzmarzly/ancs4linux

{ lib, stdenv, python3Packages, fetchFromGitHub, }:
with python3Packages;
buildPythonApplication rec {
  pname = "ancs4linux";
  version = "0.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pzmarzly";
    repo = "ancs4linux";
    rev = "master";
    hash = "sha256-iP4OkWvX2RjMPQYoR+erQoB10d7+4NKYFsJoZUqhcDs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>="
  '';

  nativeBuildInputs = [ poetry-core setuptools-scm pygobject dasbus typer ];
}
