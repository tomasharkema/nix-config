# https://github.com/pzmarzly/ancs4linux

{ lib, stdenv, python3Packages, fetchFromGitHub, fetchPypi, inputs, pkgs, }:
(inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }).mkPoetryApplication {
  pname = "ancs4linux";
  version = "0.0.1";
  # format = "pyproject";

  projectDir = fetchFromGitHub {
    owner = "pzmarzly";
    repo = "ancs4linux";
    rev = "ce8d3f173fd14566e516334ef23af632d840d64e";
    hash = "sha256-iP4OkWvX2RjMPQYoR+erQoB10d7+4NKYFsJoZUqhcDs=";
  };
}
# with python3Packages;
# let
#   typerOld = typer.overrideAttrs (old: rec {
#     pname = "typer";
#     version = "0.4.2";

#     src = fetchPypi {
#       inherit pname version;
#       hash = "sha256-uCYcbAFS3XNHi1upa6Z35daUjHFcMQ98kQefMR9i7AM=";
#     };
#     # nativeBuildInputs = old.nativeBuildInputs ++ [ flit-core ];
#     propagatedBuildInputs = old.propagatedBuildInputs ++ [ flit-core ];
#   });
# in
# buildPythonApplication rec {
#   pname = "ancs4linux";
#   version = "0.0.1";
#   format = "pyproject";

#   src = fetchFromGitHub {
#     owner = "pzmarzly";
#     repo = "ancs4linux";
#     rev = "ce8d3f173fd14566e516334ef23af632d840d64e";
#     hash = "sha256-iP4OkWvX2RjMPQYoR+erQoB10d7+4NKYFsJoZUqhcDs=";
#   };

#   postPatch = ''
#     substituteInPlace pyproject.toml \
#     --replace poetry.masonry.api poetry.core.masonry.api \
#     --replace "poetry>=" "poetry-core>="
#   '';

#   nativeBuildInputs = [
#     poetry-core
#     setuptools-scm
#     pygobject3
#     dasbus
#     typerOld
#   ];
# }
